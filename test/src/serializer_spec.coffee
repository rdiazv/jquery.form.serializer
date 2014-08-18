
describe '$.fn.getSerializedForm.Serializer', ->
  beforeEach ->
    @serializer = new $.fn.getSerializedForm.Serializer

  describe '.serializeField(name, value)', ->
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
