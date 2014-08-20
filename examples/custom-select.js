
// Sample plugin for custom controls.

(function($) {

  $.fn.customSelect = function() {
    return this.each(function() {
      var $this, $text;

      this.type = "CUSTOM_SELECT"

      $this = $(this);
      $text = $(this).find("[data-custom-select-text]");

      $this.on("click", ".dropdown-menu a", function() {
        var value, text;

        value = $(this).data("value");
        text = $(this).text();

        $this.val(value);
        $text.text(text);

        $(this).parent().addClass("active").siblings().removeClass("active");
      });
    });
  }

  $.valHooks.CUSTOM_SELECT = {
    get: function(el) {
      return $(el).data("custom-select-value");
    },
    set: function(el, value) {
      return $(el).data({ "custom-select-value": value });
    }
  };

})(jQuery);
