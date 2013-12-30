module.exports = (grunt) ->

  require('load-grunt-tasks') grunt

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    watch:
      scripts:
        files: ['coffee/*.coffee']
        tasks: ['coffee']
      styles:
        files: ['scss/*.scss']
        tasks: ['sass','concat:styles']
    coffee:
      all:
        expand: true
        flatten: true
        cwd: 'coffee'
        src: ['*.coffee'],
        dest: 'script',
        ext: '.js'
    sass:
      all:
        expand: true
        flatten: true
        cwd: 'scss'
        src: ['*.scss'],
        dest: '.tmp',
        ext: '.css'
    concat:
      styles:
        files:
          'css/main.css': [
            '.tmp/main.css'
            'script/lib/backpack/css/ActionView.css'
            'script/lib/backpack/css/EditableListView.css'
          ]
    concurrent:
      all: ['coffee','sass']

  grunt.registerTask 'default', ['concurrent']
