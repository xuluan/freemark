$ = jQuery.sub()
Bmark = App.Bmark

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Bmark.find(elementID)

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Bmark.find(id)
    @render()
    
  render: ->
    @html @view('bmarks/edit')(@item)

  back: ->
    @navigate '/bmarks'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/bmarks'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Bmark.bind 'refresh change', @render
    Bmark.fetch()
    
  render: =>
    bmarks = Bmark.all()
    @html @view('bmarks/index')(bmarks: bmarks)

  edit: (e) ->
    item = $(e.target).item()
    @navigate '/bmarks', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  new: ->
    @navigate '/bmarks/new'
    

class BmarkItem extends Spine.Controller
  # Delegate the click event to a local handler
  events:
    "click": "click"
    'click [data-type=edit]': 'edit'

  className: 'item'


  # Bind events to the record
  constructor: ->
    super
    throw "@item required" unless @item
    @item.bind("update", @render)
    @item.bind("destroy", @remove)


  render: (item) =>
    @item = item if item
    @html(@template(@item))
    @

  # Use a template, in this case via Eco
  template: (item) ->
    @view('bmarks/show')(item)

  # Called after an element is destroyed
  remove: ->
    @el.remove()

  # We have fine control over events, and 
  # easy access to the record too
  click: ->

  edit: ->
    @el.addClass("editing")


class New extends Spine.Controller
  events:
    'click .new-bmark': 'add'
    'click .back': 'back'
    'submit form': 'submit'

  className: 'add-bmark'
    
  constructor: ->
    super
    @active @render
    Bmark.bind 'error', @error

  error: (model, error) =>
    alert(error)
    Spine.Log.log error
    
  render: (item) =>
    @item = item if item
    @html(@template(@item))
    @

  # Use a template, in this case via Eco
  template: (item) ->
    @view('bmarks/new')(item)

  add: ->
    @el.addClass("editing")

class App.Bmarks extends Spine.Controller
  events:
    "click": "click"
    'click .new-bmark': 'add_bmark'

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
