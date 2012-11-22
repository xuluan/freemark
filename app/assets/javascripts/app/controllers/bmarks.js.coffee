$ = jQuery.sub()
Bmark = App.Bmark

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Bmark.find(elementID)

class BmarkItem extends Spine.Controller
  # Delegate the click event to a local handler
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=cancel]': 'cancel'
    'submit form': 'save'
    'ajaxSuccess': "showTagging"

  className: 'item'

  # Bind events to the record
  constructor: ->
    super
    throw "@item required" unless @item
    @item.bind("update", @render)
    @item.bind("destroy", @remove)
    App.Tagging.fetchByBmark(@item.id)

  render: (item) =>
    @item = item if item
    @html(@template(@item))
    @

  showTagging: (result) ->
    @item.taggings = App.Tagging.all()
    console.log(@item.id) if @item.taggings.length > 0

  # Use a template, in this case via Eco
  template: (item) ->
    @view('bmarks/show')(item)

  destroy: (e) ->
    App.x = this
    @item.destroy() if confirm('Sure?')

  remove: =>
    @el.remove()

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

class New extends Spine.Controller
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

class App.Bmarks extends Spine.Controller

  el: "#bmarks"
  elements:
    ".items":     "items"
    ".new-bmark": "add"

  constructor: ->
    super
    Bmark.bind("refresh", @addAll)
    Bmark.bind("create",  @addOne)
    Bmark.fetch()
    @addBmark()
    @

  addOne: (item) =>
    bmark = new BmarkItem(item: item)
    # bmark.render()
    @items.append(bmark.render().el)

  addAll: =>
    Bmark.each(@addOne)

  addBmark: ->
    addbmark = new New()
    @add.append(addbmark.render().el)
