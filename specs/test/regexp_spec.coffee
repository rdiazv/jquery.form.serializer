
describe '$._jQueryFormSerializer.regexp', ->
  describe 'simple', ->
    beforeEach ->
      @regexp = $._jQueryFormSerializer.regexp.simple

    it 'should match against simple field names', ->
      expect('simple_field').to.match(@regexp)

    it 'should not match against array field names', ->
      expect('array_field[]').to.not.match(@regexp)

  describe 'array', ->
    beforeEach ->
      @regexp = $._jQueryFormSerializer.regexp.array

    it 'should match against array field names', ->
      expect('array_field[]').to.match(@regexp)

    it 'should not match against simple field names', ->
      expect('simple_field').to.not.match(@regexp)
