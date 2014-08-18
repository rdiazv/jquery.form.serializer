
# About the "name" attribute
# http://www.w3.org/TR/html4/types.html#h-6.2

(($) ->

  regexp =
    simple: /^[a-z][\w-:\.]*$/i
    array: /^([a-z][\w-:\.]*)\[\]$/i
    named: /^([a-z][\w-:\.]*)\[(.+)\]$/i

  class Serializer
    constructor: ($this) ->
      @$this = $this

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

    serialize: ->

  $.fn.getSerializedForm = ->
    new $.fn.getSerializedForm.Serializer(@first()).serialize()

  $.fn.getSerializedForm.regexp = regexp
  $.fn.getSerializedForm.Serializer = Serializer

)(jQuery)
