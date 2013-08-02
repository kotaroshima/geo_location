requirejs.config
  paths:
    text: ['http://cdnjs.cloudflare.com/ajax/libs/require-text/2.0.3/text']
    jQuery: ['http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery']
    jQueryUI: ['http://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.10.2/jquery-ui']
    jQueryUITouchPunch: ['http://cdnjs.cloudflare.com/ajax/libs/jqueryui-touch-punch/0.2.2/jquery.ui.touch-punch.min']
    Underscore: ['http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore']
    Backbone: ['http://cdnjs.cloudflare.com/ajax/libs/backbone.js/1.0.0/backbone']
    Backpack: ['lib/backpack/Backpack-all']
    QUnit: ['http://cdnjs.cloudflare.com/ajax/libs/qunit/1.11.0/qunit']
  shim:
    text:
      exports: 'text'
    jQuery:
      exports: '$'
    jQueryUI:
      deps: ['jQuery']
      exports: '$'
    jQueryUITouchPunch:
      deps: ['jQuery', 'jQueryUI']
      exports: '$'
    Underscore:
      exports: '_'
    Backbone:
      deps: ['Underscore', 'jQuery']
      exports: 'Backbone'
    Backpack:
      deps: ['jQuery', 'Underscore', 'Backbone']
      exports: 'Backpack'
    QUnit:
      exports: 'QUnit'
      init:->
        QUnit.config.autoload = false
        QUnit.config.autostart = false
        return

require(
#  ['QUnit', 'Backbone', 'test/HistoryViewTest', 'test/LocationServiceTest'],
#  (QUnit, Backbone, HistoryViewTest, LocationServiceTest)->
  ['QUnit', 'Backbone', 'test/AppViewTest', 'test/LocationServiceTest'],
  (QUnit, Backbone, AppViewTest, LocationServiceTest)->
#  ['QUnit', 'LocationServiceTest'],
#  (QUnit, LocationServiceTest)->
    ### override so that it won't try to save to server ###
    Backbone.sync =->
    
    AppViewTest.run()
    LocationServiceTest.run()

    QUnit.load()
    QUnit.start()
    return
)