{$} = require 'atom-space-pen-views'

errorStatus = false

resetJedi= (newValue) ->
  try
    atom.packages.disablePackage('python-jedi')
  catch error
    console.log error

  atom.packages.enablePackage('python-jedi')

module.exports =
class JediProvider
  id: 'python-jedi'
  selector: '.source.python'
  providerblacklist: null

  constructor: ->
    @providerblacklist =
      'autocomplete-plus-fuzzyprovider': '.source.python'
      'autocomplete-plus-symbolprovider': '.source.python'


#This function is used to kill the jedi which is running background
  kill_Jedi : (cp,isWin, pid) ->
    if not isWin
      try
        process.kill(pid)
      catch error
        errorStatus = true
    else
      try
        win_Command = 'taskkill /F /PID ' + pid
        cp.exec win_Command
      catch error
        errorStatus = true
    return errorStatus


  requestHandler: (options) ->
    return new Promise (resolve) ->

      suggestions = []

      bufferPosition = options.cursor.getBufferPosition()

      text = options.buffer.cachedText
      row = options.cursor.getBufferPosition().row
      column = options.cursor.getBufferPosition().column

      resolve(suggestions) unless column isnt 0

      payload =
        source: text
        line: row
        column: column

      prefixRegex = /\b((\w+[\w-]*)|([.:;[{(< ]+))$/g

      prefix = options.prefix.match(prefixRegex)?[0] or ''

      if prefix is " "
        prefix = prefix.replace(/\s/g,'')

      tripleQuotes = (/(\'\'\')/g).test(options.prefix)
      line = options.editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
      hash = line.search(/(\#)/g);
      
      if hash < 0 && not tripleQuotes
        $.ajax

          url: 'http://127.0.0.1:7777'
          type: 'POST'
          data: JSON.stringify payload

          success: (data) ->

            # build suggestions
            if data.length isnt 0
              for index of data

                label = data[index].description

                if label.length > 80
                  label = label.substr(0, 80)
                suggestions.push({
                  text: data[index].name,
                  replacementPrefix: prefix,
                  label: label,

                })

            resolve(suggestions)
      else
        suggestions =[]
        resolve(suggestions)
        
  error: (data) ->
    console.log "Error communicating with server"
    console.log data

#observe settings
atom.config.onDidChange 'python-jedi.Pathtopython', (newValue, oldValue) ->
  isPathtopython = atom.config.get('python-jedi.enablePathtopython')
  if isPathtopython
    atom.config.set('python-jedi.Pathtopython', newValue)
    resetJedi(newValue)

atom.config.onDidChange 'python-jedi.enablePython2', ({newValue, oldValue}) ->
#  console.log 'My configuration changed:', newValue, oldValue
  resetJedi(newValue)

atom.config.onDidChange 'python-jedi.enablePathtopython', ({newValue, oldValue}) ->
  resetJedi(newValue)
