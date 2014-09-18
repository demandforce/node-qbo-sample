$(document).ready(function(){
  $('.requestReview').on('click',function(e){
      var thisel = $(this);
      var params = {
      firstName : thisel.data('customername'),
      email: thisel.data('email'),
      businessName : $('#businessName').val(),
      businessId : thisel.data('businessid')
    };

    $.get('/email',params,function(e,r) {
      thisel.siblings('.reviewSuccess').show(300);
      thisel.hide();

    });
  });
});
