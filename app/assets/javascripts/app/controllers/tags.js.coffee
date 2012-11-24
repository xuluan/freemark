$ = jQuery.sub()
Tag = App.Tag

class App.Tags extends Spine.Controller
  events:
    'click': 'click'

  className: 'tags'

  constructor: ->
    super
    Tag.bind("refresh change", @render)
    Tag.fetch()
    
  render: =>
    tags = Tag.select (record) ->
      record.taggings_count > 0
      
    @html @view('tags/index')(tags: tags)
    
  click: ->
