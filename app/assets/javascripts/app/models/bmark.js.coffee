class App.Bmark extends Spine.Model
  @configure 'Bmark', 'title', 'link', 'desc'
  @extend Spine.Model.Ajax.Methods
  
  @fetch (params) ->
    index  = @first()?.id or 9999999999
    if index is @index
      return false 
    @index = index
    
    params or= 
      data: {index: index}
      processData: true

    @ajax().fetch(params)

  @change (record, type, options = {}) ->
    return if options.ajax is false
    record.ajax()[type](options.ajax, options)    

  validate: ->
    url_format = /^https?\:\/\/.+$/
    unless url_format.exec(@link)
      "Link: invalid url"

  @filter: (filters) =>
    result = (filter.name for filter in filters)
    @trigger("filter", result)


  filter: (filters) =>
    @taggings or= []
    tags = (tag.name for tag in @taggings)
    for filter in filters
      return false unless filter in tags
    true
