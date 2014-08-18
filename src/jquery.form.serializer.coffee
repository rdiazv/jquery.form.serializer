
# About the "name" attribute
# http://www.w3.org/TR/html4/types.html#h-6.2

(($) ->

  regexp =
    simple: /^[a-zA-Z][a-zA-Z0-9-_:\.]*$/
    array: /^([a-zA-Z][a-zA-Z0-9-_:\.]*)\[\]$/
    named: /^([a-zA-Z][a-zA-Z0-9-_:\.]*)\[(.+)\]$/

  class Serializer
    serializeField: (name, value) ->
      response = {}

      if regexp.simple.test(name)
        response[name] = value

      else if matches = name.match(regexp.array)
        response[matches[1]] = [value]

      else if matches = name.match(regexp.named)
        response[matches[1]] = {}
        response[matches[1]][matches[2]] = value

      response

  $.fn.getSerializedForm = (options = {}) ->
    this.each ->

  $.fn.getSerializedForm.regexp = regexp
  $.fn.getSerializedForm.Serializer = Serializer

)(jQuery)
