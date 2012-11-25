$ = jQuery.sub()
Bmark = App.Bmark
Filter = App.Filter


$.fn.tagName = ->
  elementName   = $(@).data('name')
  elementName or= $(@).parents('[data-name]').data('name')


class App.Filters extends Spine.Controller
  events:
    'click a.icon-remove': 'delFilter'
    'click button': 'clear'

  className: 'filters'

  constructor: ->
    super
    Filter.bind("refresh change", @render)
    Filter.fetch()
    
  render: =>
    filters = Filter.all()
    @html @view('filters/index')(filters: filters)
    Bmark.filter(filters)
    @
    
  delFilter: (e) ->
    tagName = $(e.target).tagName()
    for filter in Filter.all() when filter.name is tagName
      filter.destroy()

  clear: (e) ->
    Filter.destroyAll()
