
# About the "name" attribute
# http://www.w3.org/TR/html4/types.html#h-6.2

(($) ->

  regexp =
    simple: /^[a-zA-Z][a-zA-Z0-9-_:\.]*$/

  class Serializer
    serializeField: (name, value) ->
      response = {}
      response[name] = value if regexp.simple.test(name)
      response

  $.fn.getSerializedForm = (options = {}) ->
    this.each ->

  $.fn.getSerializedForm.regexp = regexp
  $.fn.getSerializedForm.Serializer = Serializer

)(jQuery)
