class App.Bmark extends Spine.Model
  @configure 'Bmark', 'title', 'link', 'desc'
  @extend Spine.Model.Ajax

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





