
cp = require 'child_process'
JediProvider = require './jedi-python3-provider'
isWin = /^win/.test(process.platform)
errorStatus = false

module.exports =

  # python-jedi config schema
  config:
    enablePython2:
      description: 'Check to enable autocomplete for Python2 (AutoComplete for Python3 will be disabled)'
      type: 'boolean'
      default: false
    enablePathtopython:
        description: 'Check to enable above Pathtopython field to work'
        type: 'boolean'
        default: false
    Pathtopython:
      description:'Python virtual environment path (eg:/home/user/py3pyenv/bin/python3 or home/user/py2virtualenv/bin/python)'
      type: 'string'
      default: 'python3'

  provider: null

  jediServer: null

  activate: ->
    if !@jediServer
      projectPath = atom.project.getPaths()
      isPy2 = atom.config.get('python-jedi.enablePython2')
      isPathtopython = atom.config.get('python-jedi.enablePathtopython')
#      if isWin
      if isPy2
        if isPathtopython
          command = atom.config.get('python-jedi.Pathtopython') + " " + __dirname +
                    "/jedi-python2-complete.py '"  + projectPath + "'"
        else
          command = "python " + __dirname +
                    "/jedi-python2-complete.py '"  + projectPath + "'"
      else
        if isPathtopython
          command = atom.config.get('python-jedi.Pathtopython') + " " + __dirname +
                    "/jedi-python3-complete.py '"  + projectPath + "'"
        else
          command = "python3 " + __dirname +
                    "/jedi-python3-complete.py '"  + projectPath + "'"

      @jediServer = cp.exec command

    @provider = new JediProvider()

  serialize: ->
     pid = @jediServer.pid
     @provider.kill_Jedi(cp, isWin, pid)

  deactivate: ->
     pid = @jediServer.pid
     errorStatus = @provider.kill_Jedi(cp, isWin, pid)
     @jediServer = null

  getProvider: ->
    return {providers: [@provider]}
