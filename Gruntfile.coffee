module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    copy:
      dist:
        expand: true
        cwd: 'src/'
        src: 'config.json'
        dest: 'dist/'
    clean:
      dist: ['dist/']
    shell:
      app:
        command: 'npm start'

  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-shell')


  grunt.registerTask('default', ['clean:dist', 'copy:dist'])
  grunt.registerTask('dev', ['shell:app'])
