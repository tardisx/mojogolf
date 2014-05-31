$( document ).ready(function() {
  $('#myTab a').click(function (e) {
    console.log("triggered");
    $(this).tab('show')
  });
});
