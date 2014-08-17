
describe 'jquery.form.serializer', ->
  it 'should define a jQuery function named getSerializedForm', ->
    expect($()).to.respondTo("getSerializedForm")
