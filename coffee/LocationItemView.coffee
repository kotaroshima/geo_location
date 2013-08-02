###
* A view for each items in the search result list
###
define(
  ['Underscore', 'Backpack', 'text!template/LocationItemView.html'],
  (_, Backpack, viewTemplate)->
    Backpack.View.extend
      template: _.template viewTemplate

      events:
        'click .location-item': 'onClicked'

      initialize:(options)->
        @render()
        return

      render:->
        # add view helper to format numbers
        data = _.extend @model.attributes, {
          formatNumber: (num, precision=2)->
            pow = Math.pow 10, precision
            Math.round(num*pow)/pow
        }
        @$el.html @template data
        @

      ###
      * Click event handler for this item (row)
      ###
      onClicked:->
        Backbone.trigger 'SEARCH_ADDRESS', @model.attributes.formatted_address
        Backbone.trigger 'SHOW_VIEW', 'searchView'
        return
)