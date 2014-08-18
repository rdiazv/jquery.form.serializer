
describe '$.fn.getSerializedForm.Serializer', ->
  beforeEach ->
    @sandbox = sinon.sandbox.create()
    @$form = $ """
      <form>
        <input type="hidden" name="token" value="ABC" />
        <input type="text" name="user[name]" value="John Doe" />
        <input type="text" name="user[email]" value="john@email.com" />
        <input type="checkbox" name="user[newsletter]" checked />
        <input type="file" name="user[image]" value="../dummy/image.png" />
        <select name="user[country]">
          <option value="CL" selected>Chile</option>
        </select>
        <input type="radio" name="user[gender]" value="male" checked />
        <input type="radio" name="user[gender]" value="female" />
        <input type="checkbox" name="user[skills][]" value="JS" checked />
        <input type="checkbox" name="user[skills][]" value="C++" />
        <input type="checkbox" name="user[skills][]" value="Java" />
        <input type="checkbox" name="user[skills][]" value="CSS" checked />
      </form>
      """

  afterEach ->
    @sandbox.restore()

  describe 'constructor($this)', ->
    it 'should save the element as an instance variable', ->
      $this = $()
      serializer = new $.fn.getSerializedForm.Serializer($this)
      expect(serializer.$this).to.eq($this)

  describe '.serializeField(name, value)', ->
    beforeEach ->
      @serializer = new $.fn.getSerializedForm.Serializer

    context 'if the name is a simple field name', ->
      it 'should return a plain value', ->
        value = @serializer.serializeField('email', 'test@email.com')
        expect(value).to.eql(email: 'test@email.com')

    context 'if the name is an array field name', ->
      context 'the key', ->
        it 'should not contain the brackets', ->
          value = @serializer.serializeField('emails[]', 'test@email.com')
          expect(value).to.have.key('emails')

      it 'should return an array', ->
        value = @serializer.serializeField('emails[]', 'test@email.com')
        expect(value).to.eql(emails: ['test@email.com'])

      it 'should merge consecutive calls to the same array field', ->
        @serializer.serializeField('emails[]', 'test1@email.com')
        value = @serializer.serializeField('emails[]', 'test2@email.com')
        expect(value).to.eql(emails: ['test1@email.com', 'test2@email.com'])

    context 'if the name is a named array field name', ->
      context 'the key', ->
        it 'should not contain the brackets', ->
          value = @serializer.serializeField('emails[john]', 'john@email.com')
          expect(value).to.have.key('emails')

      it 'should return a json object', ->
        value = @serializer.serializeField('emails[john]', 'john@email.com')
        expect(value).to.eql
          emails:
            john: 'john@email.com'

      it 'should handle nested attributes', ->
        value = @serializer.serializeField('emails[john][current]', 'john@email.com')
        expect(value).to.eql
          emails:
            john:
              current: 'john@email.com'

  describe '.getSubmittableFieldValues(options)', ->
    beforeEach ->
      @serializer = new $.fn.getSerializedForm.Serializer(@$form)

    it 'should return all submittable fields as a name, value json array', ->
      fields = @serializer.getSubmittableFieldValues()
      expect(fields).to.eql [
        { name: "token", value: "ABC" },
        { name: "user[name]", value: "John Doe" },
        { name: "user[email]", value: "john@email.com" },
        { name: "user[newsletter]", value: true },
        { name: "user[country]", value: "CL" },
        { name: "user[gender]", value: "male" },
        { name: "user[skills][]", value: "JS" },
        { name: "user[skills][]", value: "CSS" }
      ]

    it 'should ignore fields without a name', ->
      @$form.html """
        <input type="text" name="test" value="valid" />
        <input type="text" value="invalid" />
        """

      fields = @serializer.getSubmittableFieldValues()
      expect(fields).to.eql [name: "test", value: "valid"]

    it 'should be customizable by passing options', ->
      @$form.html """
        <input type="text" name="test1" value="enabled" />
        <input type="text" name="test2" value="disabled" disabled />
        """

      fields = @serializer.getSubmittableFieldValues
        submittable:
          filters:
            enabled: false

      expect(fields).to.eql [
        { name: "test1", value: "enabled" }
        { name: "test2", value: "disabled" }
      ]

    context 'working with custom controls', ->
      beforeEach ->
        $.valHooks.custom_control =
          get: (el) ->
            $(el).data("value")

          set: (el, value) ->
            $(el).data("value": value)

      afterEach ->
        delete $.valHooks.custom_control

      it 'should work with custom control types', ->
        $control = $("""<div class="custom-control" name="custom"/>""")
        $control.data("value": "my value")
        $control.get(0).type = "custom_control"
        @$form.html($control)

        fields = @serializer.getSubmittableFieldValues
          submittable:
            selector: "#{$.fn.getSerializedForm.submittable.selector}, .custom-control"

        expect(fields).to.eql [name: "custom", value: "my value"]

    it 'should call value castings on every field', ->
      @$form.html """
        <input type="text" value="123" name="field1" class="numeric" />
        <input type="text" value="123" name="field2" />
        """

      fields = @serializer.getSubmittableFieldValues
        castings:
          numericFields: ->
            if $(this).hasClass("numeric")
              parseInt($(this).val())

      expect(fields).to.eql [
        { name: "field1", value: 123 }
        { name: "field2", value: "123" }
      ]

  describe '.serialize(options = {})', ->
    beforeEach ->
      @serializer = new $.fn.getSerializedForm.Serializer(@$form)

    it 'should return a json with all the submittable field values serialized', ->
      expect(@serializer.serialize()).to.eql
        token: 'ABC'
        user:
          name: "John Doe"
          email: "john@email.com"
          newsletter: true
          country: "CL"
          gender: "male"
          skills: ["JS", "CSS"]

    it 'should pass the options to getSubmittableFieldValues', ->
      @sandbox.spy $.fn.getSerializedForm.Serializer.prototype, "getSubmittableFieldValues"

      options = { option1: 1 }

      @serializer.serialize(options)

      expect($.fn.getSerializedForm.Serializer::getSubmittableFieldValues).to
        .have.been.calledWith(options)
