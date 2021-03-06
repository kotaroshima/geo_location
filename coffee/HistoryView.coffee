###
* A view for displaying address search history
###
define(
  ['Underscore', 'Backpack', 'LocationItemView', 'text!template/HistoryView.html'],
  (_, Backpack, LocationItemView, viewTemplate)->
    Backpack.View.extend
      template: _.template viewTemplate

      events:
        'click #history-back-button': 'onBackButtonClick'
        'click #history-edit-button': 'onEditButtonClick'
        'click #history-done-button': 'onDoneButtonClick'

      ###
      * Sets up history view
      ###
      initialize:(options)->
        Backpack.View::initialize.apply @, arguments
        @render()

        collection = @collection = new Backpack.Collection null,
          model: Backpack.Model
          subscribers:
            ADD_LOCATION_HISTORY: 'addLocationHistory'
          addLocationHistory:(models, options)->
            return if !models || models.length == 0
            formatted_address = models[0].get 'formatted_address'
            found = _.find collection.models, (m)->
              formatted_address == m.get 'formatted_address'
            @add.apply @, arguments if (!found || found.length == 0)

        listView = @listView = new Backpack.EditableListView
          collection: collection
          itemView: LocationItemView
          itemOptions:
            onClick:->
              Backbone.trigger 'SEARCH_ADDRESS', @model.attributes.formatted_address
              Backbone.trigger 'SHOW_VIEW', 'searchView'
              return
        @$('#history-list-container').append listView.$el

        return

      ###
      * Renders template HTML
      ###
      render:->
        @$el.html @template()
        @

      ###
      * Toggles edit mode of this view
      * @param {Boolean} isEdit a flag to specify edit mode or not
      ###
      setEditable:(isEdit)->
        @listView.setEditable isEdit
        @$el.toggleClass 'history-edit', isEdit
        return

      ###
      * Click event handler for [Back] button
      * When clicked, it returns to search view
      ###
      onBackButtonClick:->
        @setEditable false
        return

      ###
      * Click event handler for [Edit] button
      * When clicked, it enters edit mode
      ###
      onEditButtonClick:->
        @setEditable true
        return

      ###
      * Click event handler for [Done] button
      * When clicked, it exits edit mode
      ###
      onDoneButtonClick:->
        @setEditable false
        return
)