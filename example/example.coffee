# Cache bust, since most of our changed code is
# in the require.js 'main' module.
require.config
  urlArgs: "bust=" + (new Date()).getTime()
  paths:
    'ice': '../dist/ice-full.min'

readFile = (name) ->
  q = new XMLHttpRequest()
  q.open 'GET', name, false
  q.send()
  return q.responseText


require ['ice'], (ice) ->
  # Example palette
  window.editor = new ice.Editor document.getElementById('editor'), [
    {
      name: 'Common',
      blocks: (ice.parse(paletteElement, wrapAtRoot: true).start.next.container for paletteElement in [
        'fd 100'
        'bk 100'
        'rt 90'
        'lt 90'
        '''
        for i in [1..10]
          fd 10
        '''
        '''
        if touches 'red'
          fd 10
        '''
        '''
        fun = (arg) ->
          return arg
        '''
      ])
    }
    {
      name: 'Turtle',
      blocks: (ice.parse(paletteElement, wrapAtRoot: true).start.next.container for paletteElement in [
        'fd 100'
        'bk 100'
        'rt 90'
        'lt 90'
        'pen red'
        'dot green, 20'
        'slide 10'
        'jumpto 0, 0'
        'turnto 0'
        'rt 90, 100'
        'lt 90, 100'
      ])
    }
    {
      name: 'Control',
      blocks: (ice.parse(paletteElement, wrapAtRoot: true).start.next.container for paletteElement in [
        '''
        if touches 'red'
          fd 10
        '''
        '''
        if touches 'red'
          fd 10
        else
          bk 10
        '''
        '''
        for element, i in list
          see element
        '''
        '''
        for key, value of obj
          see key, value
        '''
        '''
        while touches 'red'
          fd 10
        '''
      ])
    }
    {
      name: 'Functions',
      blocks: [
        ice.parseObj {
          type: 'block'
          valueByDefault: true
          color: '#26cf3c'
          children: [
            '('
            {
              type: 'socket'
              precedence: 0
              contents: 'arg'
            }
            #{
            #  type: 'mutationButton'
            #  expand: [
            #    ', '
            #    {
            #      type: 'socket'
            #      precedence: 0
            #      contents: 'arg'
            #    }
            #  0
            #  ]
            #}
            ') ->'
            {
              type: 'indent'
              depth: 2
              children: [
                '\n'
                {
                  type: 'block'
                  valueByDefault: false
                  color: '#dc322f'
                  children: [
                    'return '
                    {
                      type: 'socket'
                      precedence: 0
                      contents: 'arg'
                    }
                  ]
                }
              ]
            }
          ]
        }
        ice.parse('return arg').start.next.container
        ice.parseObj {
          type: 'block'
          valueByDefault: false
          color: '#268bd2'
          precedence: 32
          children: [
            {
              type: 'socket'
              precedence: 0
              contents: 'fn'
            },
            '('
            {
              type: 'socket'
              precedence: 0
              contents: 'arg'
            }
            #{
            #  type: 'mutationButton'
            #  expand: [
            #    ', '
            #    {
            #      type: 'socket'
            #      precedence: 0
            #      contents: 'arg'
            #    }
            #    0
            #  ]
            #}
            ')'
          ]
        }
      ]
    }
    {
      name: 'Containers',
      blocks: [
        ice.parseObj {
          type: 'block'
          valueByDefault: true
          color: '#26cf3c'
          precedence: 32
          children: [
            '['
            {
              type: 'socket'
              precedence: 0
              contents: 'el'
            }
            #{
            #  type: 'mutationButton'
            #  expand: [
            #    ', '
            #    {
            #      type: 'socket'
            #      precedence: 0
            #      contents: 'el'
            #    }
            #    0
            #  ]
            #}
            ']'
          ]
        }
        ice.parse("array.push 'hello'").start.next.container
        ice.parse("array.sort()").start.next.container
        ice.parse('{}').start.next.container
        ice.parseObj {
          type: 'block'
          valueByDefault: true
          precedence: 32
          color: '#26cf3c'
          children: [
            '{   '
            {
              type: 'indent'
              depth: 2
              children: [
                '\n'
              ]
            }
            '}'
          ]
        }
        ice.parseObj {
          type: 'block'
          color: '#268bd2'
          children: [
            {
              type: 'socket'
              precedence: 0
              contents: 'property'
            }
            ':'
            {
              type: 'socket'
              precedence: 0
              contents: 'value'
            }
          ]
        }
        ice.parse("obj['hello'] = 'world'").start.next.container
      ]
    }
    {
      name: 'Logic'
      blocks: (ice.parse(paletteElement, wrapAtRoot: true).start.next.container for paletteElement in [
        '1 is 1'
        '1 isnt 2'
        'true and false'
        'false or true'
      ])
    }
    {
      name: 'Math'
      blocks: (ice.parse(paletteElement, wrapAtRoot: true).start.next.container for paletteElement in [
        '2 + 3'
        '2 - 3'
        '2 * 3'
        '2 / 3'
        '2 < 3'
        '3 > 2'
        'Math.pow 2, 3'
        'Math.sqrt 2'
        'random 10'
      ])
    }
  ]
  
  # Example program (fizzbuzz)
  examplePrograms = {
    fizzbuzz: '''
    for i in [1..1000]
      if i % 15 is 0
        see 'fizzbuzz'
      else
        if i % 5 is 0
          see 'fizz'
        if i % 3 is 0
          see 'buzz'
        if i % 3 isnt 0 and i % 5 isnt 0
          see i
    '''
    quicksort: '''
    globalNumberOfComparisons = 0
    bubblesort = (list) ->
      for _ in [1..list.length]
        for item, i in list
          globalNumberOfComparisons += 1
          if list[i] > list[i+1]
            temp = list[i]
            list[i] = list[i + 1]
            list[i + 1] = temp
      return list
    quicksort = (list) ->
      if list.length <= 1
        return list
      pivotGuess = 0
      for item in list
        globalNumberOfComparisons += 1
        pivotGuess += item / list.length
      smallerList = []
      biggerList = []
      for item in list
        globalNumberOfComparisons += 1
        if item < pivotGuess
          smallerList.push item
        else
          biggerList.push item
      sortedSmallerList = quicksort smallerList
      sortedBiggerList = quicksort biggerList
      for item in sortedBiggerList
        sortedSmallerList.push item
      return sortedSmallerList
    array = [1..1000]
    array.sort (a, b) ->
      if Math.random() > 0.5
        return 1
      else
        return -1
      return 0
    quicksort array
    quicksortSpeed = globalNumberOfComparisons
    see 'Quicksort finished in ' + globalNumberOfComparisons + ' operations'
    array.sort (a, b) ->
      if Math.random() > 0.5
        return 1
      else
        return -1
      return 0
    globalNumberOfComparisons = 0
    bubblesort array
    see 'Bubblesort finished in ' + globalNumberOfComparisons + ' operations'
    see 'Quicksort was ' + globalNumberOfComparisons / quicksortSpeed + ' times faster'
    '''
    church: '''
    zero = (f) -> (x) -> x
    church = (n) ->
      if n > 0
        return succ church n-1
      return zero
    unchurch = (n) -> n((x) -> x + 1) 0
    succ = (n) -> (f) -> (x) -> f n(f) x
    add = (m, n) -> (f) -> (x) -> m(f) n(f) x
    mult = (m, n) -> (f) -> n m f
    exp = (m, n) -> n m
    pred = (n) -> (f) -> (x) -> n((g) -> (h) -> h(g(f)))(->x)((u)->u)
    sub = (m, n) -> n(pred) m
    see unchurch exp church(2), church(6)
    see unchurch add church(3), church(10)
    see unchurch sub church(10), church(3)
    '''
    controller: readFile '/src/controller.coffee'
  }

  # Update textarea on ICE editor change
  editor.onChange = ->
    # Currently empty function
  
  # Trigger immediately
  editor.onChange()

  document.getElementById('which_example').addEventListener 'change', ->
    editor.setValue examplePrograms[@value]

  editor.setValue examplePrograms.fizzbuzz
  editor.clearUndoStack()
  
  messageElement = document.getElementById 'message'
  displayMessage = (text) ->
    messageElement.style.display = 'inline'
    messageElement.innerText = text
    setTimeout (->
      messageElement.style.display = 'none'
    ), 2000

  document.getElementById('toggle').addEventListener 'click', ->
    unless editor.toggleBlocks().success
      # If we were unsuccessful at toggling,
      # put up a message.
      unless editor.currentlyUsingBlocks or editor.currentlyAnimating
        displayMessage 'Syntax error'
