
describe '$.fn.getSerializedForm.Serializer', ->
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

  describe '.getSubmittableFieldValues()', ->
    beforeEach ->
      $form = $ """
        <form action="/">
          <input type="text" name="simple_field" value="simple_value" />
          <input type="text" name="array_field[]" value="array_value1" />
          <input type="text" name="array_field[]" value="array_value2" />
          <input type="text" name="named_field[named1]" value="named_value1" />
          <input type="text" name="named_field[named2]" value="named_value2" />
        </form>
        """

      @serializer = new $.fn.getSerializedForm.Serializer($form)

    it 'should return all submittable fields as a key, value pairs array', ->
      fields = @serializer.getSubmittableFieldValues()
      expect(fields).to.eql [
        ["simple_field", "simple_value" ],
        ["array_field[]", "array_value1" ],
        ["array_field[]", "array_value2" ],
        ["named_field[named1]", "named_value1"],
        ["named_field[named2]", "named_value2"]
      ]
