
# About the "name" attribute
# http://www.w3.org/TR/html4/types.html#h-6.2

(($) ->

  regexp =
    simple: /^[a-z][\w-:\.]*$/i
    array: /^([a-z][\w-:\.]*)\[(.*\])$/i

  selectors =
    submittable: 'input, select, textarea'
    submittableFilter: '[name]:not(:disabled)'

  class Serializer
    constructor: ($this) ->
      @$this = $this

    serializeField: (name, value) ->
      response = {}

      if regexp.simple.test(name)
        response[name] = value

      else if matches = name.match(regexp.array)
        name = matches[2].replace("]", "")

        response[matches[1]] =
          if name == "" then [value]
          else @serializeField(name, value)

      response

    getSubmittableFieldValues: ->
      fields = []

      @$this.find(selectors.submittable)
        .filter(selectors.submittableFilter).each ->
          name = $(this).attr('name')
          fields.push([name, $(this).val()])

      fields

    serialize: ->

  $.fn.getSerializedForm = ->
    new $.fn.getSerializedForm.Serializer(@first()).serialize()

  $.fn.getSerializedForm.regexp = regexp
  $.fn.getSerializedForm.selectors = selectors
  $.fn.getSerializedForm.Serializer = Serializer

)(jQuery)
