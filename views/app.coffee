dirname = (path) ->
  path.replace(/\\/g, '/').replace(/\/[^\/]*\/?$/, '')

CodeMirror.modeURL = '/resource/editor/mode/%N'

cm = CodeMirror.fromTextArea $('#editor_textarea').get(0)

this.changeTheme = (theme) ->
  $('head').append("<link rel=\"stylesheet\" type=\"text/css\" href=\"/resource/editor/theme/#{theme}\" />")
  cm.setOption 'theme', theme

this.changeTheme 'rubyblue'
  
this.loadDirectory = (path) ->
  $.getJSON "/api/files/#{path}", (data) ->
    $('#filelist').empty()
    $(data).each (i, file) ->
      $('#filelist').append("<li><a href=\"\##{file.path.substr(1)}\">#{file.name}</a></li>")

this.loadFile = (path) ->
  $.getJSON "/api/files/#{path}", (data) ->
    window.loadDirectory data.base
    cm.setValue data.contents
    cm.setOption 'mode', data.language
    CodeMirror.autoLoadMode cm, data.language

this.saveFile = (path, cb) ->
  $.ajax
    url: "/api/files/#{path}"
    type: 'PUT'
    data: { data: cm.getValue() }
    success: cb

this.updatePath = ->
  this.path = window.location.hash.substr 1

  if this.path.substr(-1) == '/'
    this.loadDirectory this.path
  else
    this.loadFile this.path

this.onhashchange = ->
  window.updatePath()

this.updatePath()

$('#save').click ->
  window.saveFile window.path
