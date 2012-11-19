$ = jQuery.sub()
Bmark = App.Bmark

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Bmark.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    Bmark.bind 'error', @error

  error: (model, error) =>
    alert(error)
    Spine.Log.log error
    
  render: ->
    @html @view('bmarks/new')

  back: ->
    @navigate '/bmarks'

  submit: (e) ->
    e.preventDefault()
    bmark = Bmark.fromForm(e.target).save()
    @navigate '/bmarks', bmark.id if bmark

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
    
class App.Bmarks extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    new:   New
    
  routes:
    '/bmarks/new':      'new'
    '/bmarks/:id/edit': 'edit'
    '/bmarks':          'index'
    
  default: 'index'
  className: 'stack bmarks'
  el: "#bmarks"