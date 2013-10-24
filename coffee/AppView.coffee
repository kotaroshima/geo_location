###
* A application view
###
define(
  ['jQueryUI', 'Backpack', 'SearchView', 'HistoryView'],
  ($, Backpack, SearchView, HistoryView)->
    Backpack.View.extend

      ###
      * Sets up main view
      ###
      initialize:(options)->
        Backpack.View::initialize.apply @, arguments

        searchView = new SearchView
          name: 'searchView'
    
        historyView = new HistoryView
          name: 'historyView'
    
        @stackView = new Backpack.StackView
          children: [searchView, historyView]
          navigationEvents:
            searchView: 
              event: 'onHistoryButtonClick'
              target: 'historyView'
            historyView:
              event: 'onBackButtonClick'
              back: true
          subscribers:
            SHOW_VIEW: 'showChild'
        @$el.append @stackView.$el
        return
)   