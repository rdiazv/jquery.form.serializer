
describe '$.fn.getSerializedForm.Serializer', ->
  beforeEach ->
    @serializer = new $.fn.getSerializedForm.Serializer

  describe '.serializeField(name, value)', ->
    context 'if the name is a simple field name', ->
      it 'should return a plain json', ->
        value = @serializer.serializeField('email', 'test@email.com')
        expect(value).to.eql(email: 'test@email.com')
