$(document).ready(function(){
  $('.requestReview').on('click',function(e){
      var transaction = $(this);
      var params = {
      firstName : transaction.data('customername'),
      email: transaction.data('email'),
      businessName : $('#businessName').val(),
      businessId : transaction.data('businessid')
    };

    $.get('/email',params,function(e,r) {
      alert("A review has been requested from the customer.");
      transaction.siblings('.reviewSuccess').show();
      transaction.hide();

    });
  });
});
