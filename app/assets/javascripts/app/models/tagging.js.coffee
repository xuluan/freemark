class App.Tagging extends Spine.Model
  current_bmark: null
  @configure 'Tagging', 'name', 'bmark_id'

  @extend Spine.Model.Ajax.Methods
  
  @fetch (params) ->
    if @current_bmark
      params =
        data: {bmark_id: @current_bmark}
        processData: true
    @ajax().fetch(params)


  @fetchByBmark: (bmark_id) ->
    @current_bmark = bmark_id
    @fetch({})
    # @current_bmark = null
