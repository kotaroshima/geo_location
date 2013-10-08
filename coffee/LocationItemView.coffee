###
* A view for each items in the search result list
###
define(
  ['Underscore', 'Backpack', 'text!template/LocationItemView.html'],
  (_, Backpack, viewTemplate)->
    Backpack.View.extend
      template: _.template viewTemplate
      attributes:
        class: 'location-item'

      events:
        'click .location-item': 'onClicked'

      initialize:(options)->
        Backpack.View::initialize.apply @, arguments
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

      onClicked:->
 )