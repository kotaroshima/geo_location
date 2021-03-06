/*
* A view for displaying address search history
*/


(function() {
  define(['Underscore', 'Backpack', 'LocationItemView', 'text!template/HistoryView.html'], function(_, Backpack, LocationItemView, viewTemplate) {
    return Backpack.View.extend({
      template: _.template(viewTemplate),
      events: {
        'click #history-back-button': 'onBackButtonClick',
        'click #history-edit-button': 'onEditButtonClick',
        'click #history-done-button': 'onDoneButtonClick'
      },
      /*
      * Sets up history view
      */

      initialize: function(options) {
        var collection, listView;
        Backpack.View.prototype.initialize.apply(this, arguments);
        this.render();
        collection = this.collection = new Backpack.Collection(null, {
          model: Backpack.Model,
          subscribers: {
            ADD_LOCATION_HISTORY: 'addLocationHistory'
          },
          addLocationHistory: function(models, options) {
            var formatted_address, found;
            if (!models || models.length === 0) {
              return;
            }
            formatted_address = models[0].get('formatted_address');
            found = _.find(collection.models, function(m) {
              return formatted_address === m.get('formatted_address');
            });
            if (!found || found.length === 0) {
              return this.add.apply(this, arguments);
            }
          }
        });
        listView = this.listView = new Backpack.EditableListView({
          collection: collection,
          itemView: LocationItemView,
          itemOptions: {
            onClick: function() {
              Backbone.trigger('SEARCH_ADDRESS', this.model.attributes.formatted_address);
              Backbone.trigger('SHOW_VIEW', 'searchView');
            }
          }
        });
        this.$('#history-list-container').append(listView.$el);
      },
      /*
      * Renders template HTML
      */

      render: function() {
        this.$el.html(this.template());
        return this;
      },
      /*
      * Toggles edit mode of this view
      * @param {Boolean} isEdit a flag to specify edit mode or not
      */

      setEditable: function(isEdit) {
        this.listView.setEditable(isEdit);
        this.$el.toggleClass('history-edit', isEdit);
      },
      /*
      * Click event handler for [Back] button
      * When clicked, it returns to search view
      */

      onBackButtonClick: function() {
        this.setEditable(false);
      },
      /*
      * Click event handler for [Edit] button
      * When clicked, it enters edit mode
      */

      onEditButtonClick: function() {
        this.setEditable(true);
      },
      /*
      * Click event handler for [Done] button
      * When clicked, it exits edit mode
      */

      onDoneButtonClick: function() {
        this.setEditable(false);
      }
    });
  });

}).call(this);
