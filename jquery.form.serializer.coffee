
###
# jquery.form.serializer
#
# @copyright 2014, Rodrigo Díaz V. <rdiazv89@gmail.com>
# @link https://github.com/rdiazv/jquery.form.serializer
# @license MIT
# @version 1.1.0
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

  castings =
    booleanCheckbox: ->
      if $(this).is(":checkbox") and not $(this).attr("value")
        $(this).prop("checked")

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
      options = $.extend true, {},
        submittable: submittable
        castings: castings
      , options

      fields = []

      $submittable = @$this.find(options.submittable.selector)
        .filter(":not(:button, :submit, :file, :reset, :image)[name]")

      for _, filter of options.submittable.filters
        continue if filter == false or not filter?
        $submittable = $submittable.filter(filter)

      $submittable.each ->
        name = $(this).attr('name')

        if $(this).is(":checkbox") and not $(this).attr("value")
          value = if $(this).prop("checked") then "on" else "off"
        else
          value = $(this).val()

        for _, casting of options.castings
          continue if casting == false or not casting?
          castedValue = casting.apply(this)

          if castedValue?
            value = castedValue
            break

        fields.push(name: name, value: value)

      fields

    serialize: (options = {}) ->
      values = {}
      fields = @getSubmittableFieldValues(options)

      for field in fields
        $.extend(true, values, @serializeField(field.name, field.value))

      values

  $.fn.getSerializedForm = (options = {}) ->
    new $.fn.getSerializedForm.Serializer(@first()).serialize(options)

  $.fn.getSerializedForm.regexp = regexp
  $.fn.getSerializedForm.submittable = submittable
  $.fn.getSerializedForm.castings = castings
  $.fn.getSerializedForm.Serializer = Serializer

)(jQuery)
