class App.Filter extends Spine.Model
  @configure 'Filter', 'name'

  @extend Spine.Model.Local

  @add: (tagName) ->
    for filter in Filter.all() when filter.name is tagName
      return

    filter = new Filter()
    filter.name = tagName
    filter.save()