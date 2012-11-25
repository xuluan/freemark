$ = jQuery.sub()
Bmark = App.Bmark
Tagging = App.Tagging
Tag = App.Tag
Filter = App.Filter

$.fn.tagging = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  new Tagging(id:elementID)

$.fn.tagName = ->
  elementName   = $(@).data('name')
  elementName or= $(@).parents('[data-name]').data('name')

class BmarkItem extends Spine.Controller
  # Delegate the click event to a local handler
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=cancel]': 'cancel'
    'submit form.edit-bmark': 'save'
    'click a.icon-remove': 'delTag'
    'submit form.add-tagging': 'addTag'

  className: 'bmark'

  # Bind events to the record
  constructor: ->
    super
    throw "@item required" unless @item
    @item.bind("update", @render)
    @item.bind("destroy", @remove)
    Bmark.bind("filter", @filter)

  render: (item) =>
    @item = item if item
    @html(@template(@item))
    @

  # Use a template, in this case via Eco
  template: (item) ->
    item.taggings or= []
    @view('bmarks/show')(item)

  destroy: (e) ->
    @item.destroy() if confirm('Remove this Bookmark, sure?')
  
  delTag: (e) ->
    tagging = $(e.target).tagging()
    tagName = $(e.target).tagName()
    if confirm('Remove this tag, sure?')
      tagging.destroy() 
      $(e.target).parents('.tagging').remove()
      Tag.decTag(tagName)
      @item.taggings or= []
      @item.taggings = (tagging for tagging in @item.taggings when tagging.name isnt tagName)
      @filter(Filter.all())


  addTag: (e) =>
    e.preventDefault()
    tagging = Tagging.fromForm(e.target).save()
    tagging.bind("ajaxSuccess", @updateTag)
    e.target.name.value = ""
    @item.taggings or= []
    @item.taggings.push(tagging)
  
  updateTag: (data, args...) =>
    if data.hasOwnProperty("id")
      @$("div.taggings").append("<span class='tagging' data-id='#{data.id}' data-name='#{data.name}'> #{data.name} <a class='icon-remove'> </a> </span>")
      Tag.incTag(data.name)


  remove: =>
    @el.remove()
    Tag.fetch()

  save: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @close()

  edit: ->
    @el.addClass("editing")

  cancel: ->
    @close()

  close: ->
    @el.removeClass("editing")

  filter: (filters) =>
    if @item.filter(filters)
      @el.removeClass("hide")
    else
      @el.addClass("hide")


class AddMark extends Spine.Controller
  events:
    'click .new-bmark': 'create'
    'click [data-type=cancel]': 'cancel'
    'submit form': 'submit'

  className: 'add-bmark'
    
  constructor: ->
    super
    @active @render
    
  render: (item) =>
    @item = item if item
    @html(@template(@item))
    @

  # Use a template, in this case via Eco
  template: (item) ->
    @view('bmarks/new')(item)

  create: ->
    @el.addClass("editing")

  submit: (e) ->
    e.preventDefault()
    bmark = Bmark.fromForm(e.target).save()
    @close() if bmark

  cancel: ->
    @close()

  close: ->
    @el.removeClass("editing")

class App.Filters extends Spine.Controller
  events:
    'click a.icon-remove': 'delFilter'

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


class App.Main extends Spine.Controller

  el: "#main"
  elements:
    ".bmarks": "bmarks"
    ".add-bmark": "add"
    "#filters": "filters"

  constructor: ->
    super
    Bmark.bind("refresh", @addAll)
    Bmark.bind("create",  @addOne)
    Bmark.fetch()
    @addBmark()
    @addFilter()
    @

  addOne: (item) =>
    bmark = new BmarkItem(item: item)
    # bmark.render()
    @bmarks.append(bmark.render().el)

  addAll: =>
    Bmark.each(@addOne)
    Bmark.filter(Filter.all())

  addBmark: ->
    addbmark = new AddMark()
    @add.append(addbmark.render().el)

  addFilter: ->
    filters = new App.Filters()
    @filters.append(filters.render().el)
