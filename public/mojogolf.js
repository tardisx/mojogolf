jQuery.fn.reset = function () {
  $(this).each (function() { this.reset(); });
}

function showalert(message,alerttype) {

    $('#alert_placeholder').
    append('<div id="alertdiv" class="alert ' +  alerttype + '"><a class="close" data-dismiss="alert">×</a><span>'+message+'</span></div>')

    setTimeout(function() {


      $("#alertdiv").remove();

    }, 5000);
  }


function submitJSON(form,endpoint,data,outputFormName){

  var dataArray = JSON.stringify(data);
  $.ajax({
    type: "POST",
    url: endpoint,
    contentType:"application/json",
    data: dataArray,
    dataType:"json"
  })
  .done(function( msg ) {
    showalert("Your "+outputFormName+" has been added with the ID:"+msg.id,"alert-success");
    $(form).reset();

  })
  .fail(function(msg){
    showalert("Woops, we were unable to add the "+outputFormName,"alert-danger");
  });

}

$( document ).ready(function() {

  $(".alert").alert();

  $('#myTab a').click(function (e) {
    e.preventDefault()
    $(this).tab('show')
  });

  $('#languageForm').submit(function(e){
    e.preventDefault();
    var dataArray =
      {
        'name':$("#name",this).val(),
        'compile':$("#compile",this).val(),
        'source_filename':$("#source_filename",this).val(),
        'run':$("#run",this).val(),
        'boilerplate':$("#boilerplate",this).val(),

      }

      submitJSON($(this),"/rest/v1/languages",dataArray,"language");

  });

  $('#challengeForm').submit(function(e){
    e.preventDefault();
    var dataArray =
      {
        'name':$("#name",this).val(),
        'short_descr':$("#short_descr",this).val(),
        'long_descr':$("#long_descr",this).val(),
        'finishes':$("#finishes",this).val(),
      };

      submitJSON($(this),"/rest/v1/challenges",dataArray, "challenge");

  });


});


//alert-warning
