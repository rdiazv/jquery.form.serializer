$(function() {
  var $submitter;

  $(".custom-select").customSelect();

  $(":submit").on("click", function() {
    $submitter = $(this);
  });

  $("#e1").on("submit", function(event) {
    event.preventDefault();
    log($(this).getSerializedForm());
  });

  $("#e2").on("submit", function(event) {
    event.preventDefault();
    options = {}

    if ($submitter.data("options") == "custom") {
      options = {
        castings: {
          numericField: function() {
            if ($(this).hasClass("numeric")) {
              return parseInt($(this).val());
            }
          }
        }
      };
    }

    log($(this).getSerializedForm(options));
  });

  $("#e3").on("submit", function(event) {
    event.preventDefault();
    options = {}

    if ($submitter.data("options") == "custom") {
      options = {
        submittable: $.jQueryFormSerializer.submittable + ", .custom-select",
        filters: {
          enabledCustomSelectOnly: function() {
            if ($(this).hasClass("custom-select")) {
              return !$(this).find(".btn").hasClass("disabled");
            } else {
              return true;
            }
          }
        }
      };
    }

    log($(this).getSerializedForm(options));
  });
});

function log(serialized) {
  $(".console").text(JSON.stringify(serialized, undefined, 2));
}
