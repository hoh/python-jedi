
cp = require 'child_process'
JediProvider = require './jedi-python3-provider'
isWin = /^win/.test(process.platform)
errorStatus = false

module.exports =

  # python-jedi config schema
  config:
    enablePython2:
      description: 'Enable Python2 (AutoComplete for Python3 will be disabled)'
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
      projectPath = atom.project.getPath()
      isPy2 = atom.config.get('python-jedi.enablePython2')
      if isWin
        if isPy2
          command = atom.config.get('python-jedi.Pathtopython') + ' ' + __dirname +
                    '/jedi-python2-complete.py "'  + projectPath + '"'
        else
          command = atom.config.get('python-jedi.Pathtopython') + ' ' + __dirname +
                    '/jedi-python3-complete.py "'  + projectPath + '"'
      else
        if isPy2
          command = atom.config.get('python-jedi.Pathtopython') + ' ' + __dirname +
                    '/jedi-python2-complete.py "'  + projectPath + '"'
        else
          command = atom.config.get('python-jedi.Pathtopython') + ' ' + __dirname +
                    '/jedi-python3-complete.py "'  + projectPath + '"'

    @jediServer = cp.exec command

    @provider = new JediProvider()

  serialize: ->
     pid = @jediServer.pid+1
     @provider.kill_Jedi(cp, isWin, pid)

  deactivate: ->
     pid = @jediServer.pid+1
     errorStatus = @provider.kill_Jedi(cp, isWin, pid)
     @jediServer = null

  getProvider: ->
    return {providers: [@provider]}
