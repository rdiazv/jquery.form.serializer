
describe 'jquery.form.serializer', ->
  beforeEach ->
    @sandbox = sinon.sandbox.create()

  afterEach ->
    @sandbox.restore()

  it 'should define a jQuery function named getSerializedForm', ->
    expect($()).to.respondTo('getSerializedForm')

  describe '.getSerializedForm()', ->
    it 'should create an instance of Serializer passing the first form in the
    matching set', ->
      @sandbox.spy($.fn.getSerializedForm, 'Serializer')

      form1 = $("<form/>").get(0)
      form2 = $("<form/>").get(0)

      $forms = $()
      $forms = $forms.add(form1)
      $forms = $forms.add(form2)

      $forms.getSerializedForm()

      expect($.fn.getSerializedForm.Serializer).to.have.been.calledOnce
      expect($.fn.getSerializedForm.Serializer.getCall(0).args[0].get(0)).to.eq(form1)

    it 'should return the serialize function response', ->
      @sandbox.stub($.fn.getSerializedForm.Serializer.prototype, "serialize")
        .returns("test response")

      expect($().getSerializedForm()).to.eql("test response")
