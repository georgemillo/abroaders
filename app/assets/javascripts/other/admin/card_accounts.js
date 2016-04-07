$(document).ready(function () {

  $(".card-survey-checkbox").click(function (e) {
    var $checkbox = $(this).find("input[type=checkbox]");
    // The click handler will be called when the user clicks *anywhere* within
    // the <div>, but if they have clicked specifically on the checkbox, we
    // DON'T want to check/uncheck it via jQuery, because it's about to be
    // checked/unchecked anyway. Without wrapping this in a if statement, the
    // checkbox would be checked and then immediately unchecked.
    if (e.target.nodeName !== "INPUT") {
      $checkbox.prop("checked", !$checkbox.prop("checked"));;
    }
  });

});
