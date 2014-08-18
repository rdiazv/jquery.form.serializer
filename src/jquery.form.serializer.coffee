
# About the "name" attribute
# http://www.w3.org/TR/html4/types.html#h-6.2

(($) ->

  regexp =
    simple: /^[a-zA-Z][a-zA-Z0-9-_:\.]*$/

  $.fn.getSerializedForm = (options = {}) ->
    this.each ->

  $.fn.getSerializedForm.regexp = regexp

)(jQuery)
