$ = jQuery.sub()
Tag = App.Tag
Filter = App.Filter


$.fn.tagName = ->
  elementName   = $(@).data('name')
  elementName or= $(@).parents('[data-name]').data('name')

class App.Tags extends Spine.Controller
  events:
    'click a.icon-tag': 'addFilter'
    'click button.alpha-sort': 'setAlphaSort'
    'click button.hot-sort': 'setHotSort'

  className: 'tags'

  constructor: ->
    super
    @sortMode= @alphaSort
    Tag.bind("refresh change", @render)
    Tag.fetch()
    
  render: =>
    tags = @sortMode()
    @html @view('tags/index')(tags: tags)

  addFilter: (e) ->
    tagName = $(e.target).tagName()
    Filter.add(tagName)

  setAlphaSort: =>
    @sortMode = @alphaSort
    @render()

  setHotSort: =>
    @sortMode = @hotSort
    @render()

  alphaSort: ->
    tags = Tag.select (record) ->
      record.taggings_count > 0

    tags.sort (a, b) ->
      if a.name < b.name
        -1
      else
        1

  hotSort: ->
    tags = Tag.select (record) ->
      record.taggings_count > 0
    tags.sort (a, b) ->
      b.taggings_count - a.taggings_count