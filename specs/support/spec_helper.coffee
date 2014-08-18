
if window?
  window.expect = chai.expect
else if global?
  jsdom = require('jsdom').jsdom
  document = jsdom('<html><head></head><body></body></html>')
  global.window = document.createWindow()

  global.sinon = require('sinon')
  global.chai = require('chai')
  global.expect = chai.expect
  sinonChai = require("sinon-chai")
  chai.use(sinonChai)

  global.$ = global.jQuery = require('jquery')

