module.exports = (grunt) ->

  stylusStyles = [
    'bower_components/este-library/este/**/*.styl'
    'client/app/css/**/*.styl'
  ]

  coffeeScripts = [
    'bower_components/este-library/este/**/*.coffee'
    'client/app/js/**/*.coffee'
  ]

  soyTemplates = [
    'bower_components/este-library/este/**/*.soy'
    'client/app/js/**/*.soy'
  ]

  clientDirs = [
    'bower_components/closure-library'
    'bower_components/closure-templates'
    'bower_components/este-library/este'
    'client/app/js'
  ]

  clientDepsPath =
    'client/deps.js'

  clientDepsPrefix =
    '../../../../'

  grunt.initConfig

    # build tasks
    compass:
      dist:
        options:
          importPath:  'bower_components/foundation/scss'
          sassDir:     'client/app/scss'
          cssDir:      'client/app/css'
          environment: 'production'
          outputStyle: 'nested'
          # outputStyle: 'compressed'

    clean:
      app:
        options:
          force: true
        src: [
          'bower_components/este-library/este/**/*.{js,css}'
          'client/**/build/**.*'
          'client/**/{js,css}/**/*.{js,css}'
        ]

    stylus:
      options:
        'include css': true
        'compress': false
      all:
        files: [
          expand: true
          src: stylusStyles
          ext: '.css'
        ]
      app:
        files: [
          expand: true
          src: 'client/app/css/app.styl'
          ext: '.css'
        ]

    coffee:
      options:
        bare: true
      app:
        files: [
          expand: true
          src: coffeeScripts
          ext: '.js'
        ]

    coffee2closure:
      app:
        files: [
          expand: true
          src: coffeeScripts
          ext: '.js'
        ]

    esteTemplates:
      app:
        src: soyTemplates

    esteDeps:
      all:
        options:
          outputFile: clientDepsPath
          prefix: clientDepsPrefix
          root: clientDirs

    esteUnitTests:
      options:
        depsPath: clientDepsPath
        prefix: clientDepsPrefix
      app:
        src: [
          'bower_components/este-library/este/**/*_test.js'
          'client/**/*_test.js'
        ]

    # build --stage tasks

    cssmin:
      app:
        files:
          'client/app/build/app.css': 'client/app/css/app.css'

    esteBuilder:
      options:
        root: clientDirs
        depsPath: clientDepsPath

        # Enable faster compilation for Windows with Java 1.7+.
        # javaFlags: ['-XX:+TieredCompilation']
        compilerFlags: do ->

          # Default compiler settings. You will love advanced compilation with
          # verbose warning level.
          flags = [
            '--output_wrapper=(function(){%output%})();'
            '--compilation_level=ADVANCED_OPTIMIZATIONS'
            '--warning_level=VERBOSE'
            # experimental stuff
            # '--use_types_for_optimization'
          ]

          # Remove some code workarounds for ancient browsers.
          # IE<8 and very old Gecko and Webkit.
          flags = flags.concat [
            '--define=goog.net.XmlHttp.ASSUME_NATIVE_XHR=true'
            '--define=este.json.SUPPORTS_NATIVE_JSON=true'
            '--define=goog.style.GET_BOUNDING_CLIENT_RECT_ALWAYS_EXISTS=true'
          ]

          # Enable debug compiled mode for --stage=debug.
          if grunt.option('stage') == 'debug'
            flags = flags.concat [
              '--debug=true'
              '--formatting=PRETTY_PRINT'
              '--define=goog.DEBUG=true'
            ]
          else
            flags = flags.concat [
              '--define=goog.DEBUG=false'
            ]

          # Compiler Externs. They allow us to use thirdparty code without []
          # syntax.
          flags.concat [
            '--externs=bower_components/este-library/externs/react.js'
          ]

      app:
        options:
          namespace: 'app.start'
          outputFilePath: 'client/app/build/app.js'

      # Use this task to build specific language, /client/build/app_de.js etc.
      # appLocalized:
      #   options:
      #     namespace: 'app.start'
      #     outputFilePath: 'client/app/build/app.js'
      #     messagesPath: 'messages/app'
      #     locales: ['cs', 'de']

    # run tasks

    env:
      development:
        NODE_ENV: 'development'
      stage:
        NODE_ENV: 'stage'
      production:
        NODE_ENV: 'production'

    esteWatch:
      options:
        dirs: [
          'bower_components/closure-library/**/'
          'bower_components/este-library/este/**/'
          'client/**/{js,css}/**/'
        ]

      coffee: (filepath) ->
        files = [
          expand: true
          src: filepath
          ext: '.js'
        ];
        grunt.config ['coffee', 'app', 'files'], files
        grunt.config ['coffee2closure', 'app', 'files'], files
        ['coffee:app', 'coffee2closure:app']

      soy: (filepath) ->
        grunt.config ['esteTemplates', 'app'], filepath
        ['esteTemplates:app']

      js: (filepath) ->
        grunt.config ['esteDeps', 'all', 'src'], filepath
        grunt.config ['esteUnitTests', 'app', 'src'], filepath
        tasks = ['esteDeps:all', 'esteUnitTests:app']
        if grunt.option 'stage'
          tasks.push 'esteBuilder:app'
        tasks

      styl: (filepath) ->
        grunt.config ['stylus', 'all', 'files'], [
           expand: true
           src: filepath
           ext: '.css'
        ]
        ['stylus:all', 'stylus:app']

      css: (filepath) ->
        if grunt.option('stage')
          return 'cssmin:app'

    # other tasks

    esteExtractMessages:
      app:
        options:
          root: [
            'bower_components/este-library/este'
            'client/app/js'
          ]
          messagesPath: 'messages/app'
          languages: ['en', 'cs']

    release:
      options:
        bump: true
        add: true
        commit: true
        tag: true
        push: true
        pushTags: true
        npm: false

    'npm-contributors':
      options:
        file: 'package.json'
        commit: false
        commitMessage: 'Update contributors'

  grunt.loadNpmTasks 'grunt-bg-shell'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-env'
  grunt.loadNpmTasks 'grunt-este'
  grunt.loadNpmTasks 'grunt-este-watch'
  grunt.loadNpmTasks 'grunt-npm'
  grunt.loadNpmTasks 'grunt-release'
  grunt.loadNpmTasks 'grunt-text-replace'
  grunt.loadNpmTasks 'grunt-contrib-compass'

  grunt.registerTask 'build', 'Build app.', (app = 'app') ->
    tasks = [
      "clean:#{app}"
      "compass"
      "stylus:all"
      "coffee:#{app}"
      "coffee2closure:#{app}"
      "esteTemplates:#{app}"
      "esteDeps"
      "esteUnitTests:#{app}"
    ]
    if grunt.option 'stage'
      tasks = tasks.concat [
        "cssmin:#{app}"
        "esteBuilder:#{app}"
      ]
    grunt.task.run tasks

  grunt.registerTask 'run', 'Run stack.', (app = 'app') ->
    grunt.task.run [
      if grunt.option 'stage' then 'env:stage' else 'env:development'
      "esteWatch"
    ]

  grunt.registerTask 'default', 'Build app and run stack.', (app = 'app') ->
    grunt.task.run [
      "build:#{app}"
      "run:#{app}"
    ]