class App.Tag extends Spine.Model
  @configure 'Tag', 'name', 'taggings_count'

  @extend Spine.Model.Ajax

  @incTag: (name) =>
    @fetch()

  @decTag: (tag) =>
    @fetch()