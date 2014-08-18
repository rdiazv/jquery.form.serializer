
describe '$.fn.getSerializedForm.Serializer', ->
  beforeEach ->
    @sandbox = sinon.sandbox.create()
    @$form = $ """
      <form>
        <input type="hidden" name="token" value="ABC" />
        <input type="text" name="user[name]" value="John Doe" />
        <input type="text" name="user[email]" value="john@email.com" />
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

    it 'should return all submittable fields as a key, value pairs array', ->
      fields = @serializer.getSubmittableFieldValues()
      expect(fields).to.eql [
        ["token", "ABC" ],
        ["user[name]", "John Doe"],
        ["user[email]", "john@email.com"],
        ["user[country]", "CL"],
        ["user[gender]", "male"],
        ["user[skills][]", "JS"],
        ["user[skills][]", "CSS"],
      ]

    it 'should ignore fields without a name', ->
      @$form.html """
        <input type="text" name="test" value="valid" />
        <input type="text" value="invalid" />
        """

      fields = @serializer.getSubmittableFieldValues()
      expect(fields).to.eql [["test", "valid"]]

    it 'should be customizable by passing options', ->
      @$form.html """
        <input type="text" name="test1" value="enabled" />
        <input type="text" name="test2" value="disabled" disabled />
        """

      fields = @serializer.getSubmittableFieldValues
        submittable:
          filters:
            enabled: false

      expect(fields).to.eql [["test1", "enabled"], ["test2", "disabled"]]

  describe '.serialize(options = {})', ->
    beforeEach ->
      @serializer = new $.fn.getSerializedForm.Serializer(@$form)

    it 'should return a json with all the submittable field values serialized', ->
      expect(@serializer.serialize()).to.eql
        token: 'ABC'
        user:
          name: "John Doe"
          email: "john@email.com"
          country: "CL"
          gender: "male"
          skills: ["JS", "CSS"]

    it 'should pass the options to getSubmittableFieldValues', ->
      @sandbox.spy $.fn.getSerializedForm.Serializer.prototype, "getSubmittableFieldValues"

      options = { option1: 1 }

      @serializer.serialize(options)

      expect($.fn.getSerializedForm.Serializer::getSubmittableFieldValues).to
        .have.been.calledWith(options)
