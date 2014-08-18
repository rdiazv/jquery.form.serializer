
###
# jquery.form.serializer
#
# @copyright 2014, Rodrigo Díaz V. <rdiazv89@gmail.com>
# @link https://github.com/rdiazv/jquery.form.serializer
# @license MIT
# @version 0.1
###

(($) ->

  ###
  # About the "name" attribute
  # http://www.w3.org/TR/html4/types.html#h-6.2
  ###

  regexp =
    simple: /^[a-z][\w-:\.]*$/i
    array: /^([a-z][\w-:\.]*)\[(.*\])$/i

  selectors =
    submittable: 'input, select, textarea'
    submittableFilter: '[name]:not(:disabled)'

  class Serializer
    constructor: ($this) ->
      @$this = $this
      @arrays = {}

    serializeField: (name, value, fullName = name) ->
      response = {}

      if regexp.simple.test(name)
        response[name] = value

      else if matches = name.match(regexp.array)
        cleanName = matches[2].replace("]", "")

        if cleanName == ""
          @arrays[fullName] ?= []
          @arrays[fullName].push(value)
          response[matches[1]] = @arrays[fullName]
        else
          response[matches[1]] = @serializeField(cleanName, value, name)

      response

    getSubmittableFieldValues: ->
      fields = []

      @$this.find(selectors.submittable)
        .filter(selectors.submittableFilter).each ->
          name = $(this).attr('name')
          fields.push([name, $(this).val()])

      fields

    serialize: ->
      values = {}
      fields = @getSubmittableFieldValues()

      for field in fields
        $.extend(true, values, @serializeField(field[0], field[1]))

      values

  $.fn.getSerializedForm = ->
    new $.fn.getSerializedForm.Serializer(@first()).serialize()

  $.fn.getSerializedForm.regexp = regexp
  $.fn.getSerializedForm.selectors = selectors
  $.fn.getSerializedForm.Serializer = Serializer

)(jQuery)
