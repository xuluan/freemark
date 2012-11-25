$ = jQuery.sub()
Tag = App.Tag
Filter = App.Filter


$.fn.tagName = ->
  elementName   = $(@).data('name')
  elementName or= $(@).parents('[data-name]').data('name')

class App.Tags extends Spine.Controller
  events:
    'click a.icon-tag': 'addFilter'

  className: 'tags'

  constructor: ->
    super
    Tag.bind("refresh change", @render)
    Tag.fetch()
    
  render: =>
    tags = Tag.select (record) ->
      record.taggings_count > 0
      
    @html @view('tags/index')(tags: tags)

  addFilter: (e) ->
    tagName = $(e.target).tagName()
    Filter.add(tagName)
