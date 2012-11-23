$ = jQuery.sub()
Bmark = App.Bmark
Tagging = App.Tagging

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  new Tagging(id:elementID)

class BmarkItem extends Spine.Controller
  # Delegate the click event to a local handler
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=cancel]': 'cancel'
    'submit form.edit-bmark': 'save'
    'click a.icon-remove': 'delTag'
    'submit form.add-tagging': 'addTag'

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

  destroy: (e) ->
    @item.destroy() if confirm('Remove this Bookmark, sure?')
  
  delTag: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Remove this tag, sure?')
    $(e.target).parents('.tagging').remove()

  addTag: (e) =>
    e.preventDefault()
    tagging = Tagging.fromForm(e.target).save()
    tagging.bind("ajaxSuccess", @updateTag)
     # if tagging
  
  updateTag: (data, args...) =>
    if data.hasOwnProperty("id")
      @$("div.taggings").append("<span class='tagging label' data-id='#{data.id}'> #{data.name} <a class='icon-remove'> </a> </span>")


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
