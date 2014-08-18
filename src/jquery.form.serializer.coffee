
# About the "name" attribute
# http://www.w3.org/TR/html4/types.html#h-6.2

(($) ->

  regexp =
    simple: /^[a-zA-Z][a-zA-Z0-9-_:\.]*$/
    array: /^[a-zA-Z][a-zA-Z0-9-_:\.]*\[\]$/

  class Serializer
    serializeField: (name, value) ->
      response = {}

      if regexp.simple.test(name)
        response[name] = value

      else if regexp.array.test(name)
        name = name.substring(0, name.length - 2)
        response[name] = [value]

      response

  $.fn.getSerializedForm = (options = {}) ->
    this.each ->

  $.fn.getSerializedForm.regexp = regexp
  $.fn.getSerializedForm.Serializer = Serializer

)(jQuery)
