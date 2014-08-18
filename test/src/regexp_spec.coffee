
describe '$.fn.getSerializedForm.regexp', ->
  describe 'simple', ->
    beforeEach ->
      @regexp = $.fn.getSerializedForm.regexp.simple

    it 'should match against simple field names', ->
      expect('simple_field').to.match(@regexp)

    it 'should not match against array field names', ->
      expect('array_field[]').to.not.match(@regexp)

    it 'should not match against named array field names', ->
      expect('named_array_field[test]').to.not.match(@regexp)

  describe 'array', ->
    beforeEach ->
      @regexp = $.fn.getSerializedForm.regexp.array

    it 'should match against array field names', ->
      expect('array_field[]').to.match(@regexp)

    it 'should not match against simple field names', ->
      expect('simple_field').to.not.match(@regexp)

    it 'should not match against named array field names', ->
      expect('named_array_field[test]').to.not.match(@regexp)

  describe 'named', ->
    beforeEach ->
      @regexp = $.fn.getSerializedForm.regexp.named

    it 'should match against named array field names', ->
      expect('named_array_field[test]').to.match(@regexp)

    it 'should not match against array field names', ->
      expect('array_field[]').to.not.match(@regexp)

    it 'should not match against simple field names', ->
      expect('simple_field').to.not.match(@regexp)
