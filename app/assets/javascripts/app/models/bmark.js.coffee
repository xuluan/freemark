class App.Bmark extends Spine.Model
  @configure 'Bmark', 'title', 'link', 'desc'
  @extend Spine.Model.Ajax

  validate: ->
    url_format = /^https?\:\/\/.+$/
    unless url_format.exec(@link)
      "Link: invalid url"
