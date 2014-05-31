
function showalert(message,alerttype) {

    $('#alert_placeholder').
    append('<div id="alertdiv" class="alert ' +  alerttype + '"><a class="close" data-dismiss="alert">×</a><span>'+message+'</span></div>')

    setTimeout(function() {


      $("#alertdiv").remove();

    }, 5000);
  }

$( document ).ready(function() {

  $(".alert").alert();

  $('#myTab a').click(function (e) {
    e.preventDefault()
    $(this).tab('show')
  });

  /**
  /rest/v1/languages
  **/

  $('#languageForm').submit(function(e){
    e.preventDefault();
    var dataArray = JSON.stringify({'name':$("#name",this).val()});
    $.ajax({
      type: "POST",
      url: "/rest/v1/languages",
      contentType:"application/json",
      data: dataArray,
      dataType:"json"
    })
    .done(function( msg ) {
      showalert("Language Has Been Added with the ID:"+msg.id,"alert-success");
    })
    .fail(function(msg){
      showalert("Woops, we were unable to add the langauge","alert-danger");
    });

  });


});


//alert-warning
