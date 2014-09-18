# Parse and stringify an encrypted query parameters.
#
# The stringify method takes an object (name/value pairs), serializes it into a
# URL encoded query string, AES-CBC encrypts it with a 128-bit, prepends the key
# number and IV, and returns the resulting encoded string.
#
# The parse method does the reverse, converting an encrypted query string into
# an object.
#
# For simplicity, we include Connect middleware that automatically decryptes and
# extracts from the query parameter _e, and compatible method for formatting
# URLs by moving all query parameters into the encrypted query parameter _e.
#
# Also includes Connect middleware for storing session in encrypted cookie.
#
#
# ## Encrypting
#
# 1.  Encoding the parameters.
#
# 1.1. Parameter names and values are escaped. Space characters are replaced by
# '+' or '%20', and then reserved characters are escaped as described in
# [RFC1738], section 2.2: Non-alphanumeric characters are replaced by '%HH', a
# percent sign and two hexadecimal digits representing the ASCII code of the
# character. Line breaks are represented as "CR LF" pairs (i.e., '%0D%0A').
#
# 1.2. The property names/values are listed in no specific order. The name is
# separated from the value by '=' and name/value pairs are separated from each
# other by '&'.  Any property that has multiple values is listed multiple times
# (e.g., 'foo=one&foo=two').
#
# 2. Encrypting the parameters.
#
# 2.1. Index number of the most recent key is determined, starting with 0 for
# the first key. This is known as the key number.
#
# 2.2. The 128-bit key is determined based on the key number.
#
# 2.3. A random 128-bit initialization vector (IV) is created immediately before
# or during the encryption process.  The IV is never reused
#
# 2.4. The AES encryption algorithm is used in CBC mode with the key and IV
# obtained above to encrypt the encoded parameters generated in step 1.2. The
# result is an array of bytes.
#
# 3. Encoding for transmission.
#
# 3.1. The key number from step 2.1 (1 byte), IV from step 2.3 (16 bytes) and
# encrypted parameters from step 2.4 are concatenated to form a new byte array.
#
# 3.2. The byte array is encoded into an ASCII string by encoding each
# consecutive byte into a pair of hexadecimal digits (lower or upper case).
#
# 4. Use in URLs.
#
# 4.1. The result of step 3.2 is added to the URL as the query parameter '_e'.


Cookie  = require("express").session.Cookie
Crypto  = require("crypto")
QS      = require("querystring")
KEYS    = require("../config/keys.json")
URL     = require("url")
require "sugar"


# Integration dev and staging use production keys for now.
# Development/testing use key at index 0 (but can decrypt production URLs).
if /development|test/.test(process.env.NODE_ENV)
  QUERY_KEYS = KEYS["development"].query
  RECENT_KEY_NUM = 0
else
  QUERY_KEYS = KEYS["production"].query
  RECENT_KEY_NUM = QUERY_KEYS.length - 1

# Node.js expects the key to be … not a buffer, but a binary encoded string.
QUERY_KEYS = QUERY_KEYS.map((key)-> key && new Buffer(key, "hex").toString("binary"))


EncryptedParams =

  # Encrypts the clear-text string.
  encrypt: (clear)->
    # Each message uses a different IV, 128-bit long. Node expects it to be
    # binary-encoded string.
    iv = Crypto.randomBytes(16).toString("binary")
    cipher = Crypto.createCipheriv("aes-128-cbc", QUERY_KEYS[RECENT_KEY_NUM], iv)
    # The output of QS.stringify is utf-8, which we turn into binary data.
    crypt = cipher.update(clear, "utf8", "binary") + cipher.final("binary")
    # To encode the result we first merge everything in to a single buffer
    # key-num(1) IV(16) encrypted-query-string(n)
    buffer = new Buffer(17 + crypt.length)
    buffer[0] = RECENT_KEY_NUM
    buffer.write(iv, 1, 17, "binary")
    buffer.write(crypt, 17, null, "binary")
    return buffer.toString("hex")

  # Decrypt into clear-text string.
  decrypt: (crypt)->
    # Decode hex string and split into chunks:
    # key-num(1) IV(16) encrypted-query-string(n)
    buffer = new Buffer(crypt, "hex")
    key_num = buffer[0]
    key = QUERY_KEYS[key_num]
    unless key
      throw new Error("This key is no longer supported")
    iv = buffer.toString("binary", 1, 17)
    crypt = buffer.toString("binary", 17)
    cipher = Crypto.createDecipheriv("aes-128-cbc", key, iv)
    clear = cipher.update(crypt, "binary", "utf8") + cipher.final("utf8")
    return clear


  # Turns object (name/value pairs) into an encrypted query string.
  stringify: (query)->
    return EncryptedParams.encrypt(QS.stringify(query))

  # Parse the encrypted query string and returns an object with name/value
  # pairs.
  parse: (query)->
    return QS.parse(EncryptedParams.decrypt(query))


  # Similar to URL format, but all query parameters (url.query) are encrypted
  # and stuffed into the query parameter _e. Creates URLs compatible with the
  # middleware.
  format: (url)->
    encrypted = Object.create(url)
    if url.query
      encrypted.query = { _e: EncryptedParams.stringify(url.query) }
    else
      encrypted.search = "_e=#{EncryptedParams.encrypt(url.search)}"
    return URL.format(encrypted)

  # Connect middleware. Parses the encrypted query parameter _e and adds its
  # values to req.encrypted. Handles URLs created by the format method.
  #
  # If it fails to parse the query parameter, sets req.encrypted to object with
  # an error property.
  middleware: ->
    return (req, res, next)->
      if req.query._e
        try
          req.encrypted = EncryptedParams.parse(req.query._e)
        catch error
          req.encrypted = { error: error }
      next()


  # Connect middleware to store session in encrypted cookie.
  #
  # You can access the session via `req.session`. To clear the session, set `req.session = null`.
  #
  # Supports options:
  # cookie  - Session cookie settings, defaulting to `{ path: '/', httpOnly: true, maxAge: null }`
  # key     - Cookie key for storing the session (defaults to "session")
  # proxy   - Trust the reverse proxy when setting secure cookies (via "x-forwarded-proto")
  session: (options = {})->
    key = options.key || "session"
    proxy = options.proxy

    return (req, res, next)->
      # Default to empty session
      req.session ||= {}
      cookie = req.session.cookie = new Cookie(options.cookie)

      # Detect pathname mismatch
      if ~req.originalUrl.indexOf(cookie.path)
        raw = req.cookies[key]
        if raw
          try
            clear = EncryptedParams.decrypt(raw)
            req.session = JSON.parse(clear)
          catch ex

      # Session has unique ID, 32 bytes.
      req.session.id ||= Crypto.randomBytes(64).toString("base64")

      res.once "header", ->
        unless req.session
          # Clear sesion
          cookie.expires = new Date(0)
          res.setHeader("Set-Cookie", cookie.serialize(key, ""))
          return

        delete req.session.cookie

        # Only send secure cookies via https
        proto = (req.headers["x-forwarded-proto"] || "").toLowerCase()
        tls = req.connection.encrypted || (proxy && "https" == proto)
        if cookie.secure && !tls
          return

        crypt = EncryptedParams.encrypt(JSON.stringify(req.session))
        res.setHeader("Set-Cookie", cookie.serialize(key, crypt))

      next()


module.exports = EncryptedParams
