
###
# jquery.form.serializer
#
# @copyright 2014, Rodrigo Díaz V. <rdiazv89@gmail.com>
# @link https://github.com/rdiazv/jquery.form.serializer
# @license MIT
# @version 0.2
###

(($) ->

  ###
  # About the "name" attribute
  # http://www.w3.org/TR/html4/types.html#h-6.2
  ###

  regexp =
    simple: /^[a-z][\w-:\.]*$/i
    array: /^([a-z][\w-:\.]*)\[(.*\])$/i

  submittable =
    selector: 'input, select, textarea'
    filters:
      enabled: ->
        $(this).is(":not(:disabled)")

      checked: ->
        if $(this).is(":checkbox, :radio")
          $(this).is(":checked")
        else
          true

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

    getSubmittableFieldValues: (options) ->
      options = $.extend(true, {}, submittable: submittable, options)
      fields = []

      $submittable = @$this.find(options.submittable.selector).filter("[name]")

      for _, filter of options.submittable.filters
        continue if filter == false or not filter?
        $submittable = $submittable.filter(filter)

      $submittable.each ->
        name = $(this).attr('name')
        fields.push([name, $(this).val()])

      fields

    serialize: (options = {}) ->
      values = {}
      fields = @getSubmittableFieldValues(options)

      for field in fields
        $.extend(true, values, @serializeField(field[0], field[1]))

      values

  $.fn.getSerializedForm = (options = {}) ->
    new $.fn.getSerializedForm.Serializer(@first()).serialize(options)

  $.fn.getSerializedForm.regexp = regexp
  $.fn.getSerializedForm.submittable = submittable
  $.fn.getSerializedForm.Serializer = Serializer

)(jQuery)
