module.exports = (grunt) ->

  require('load-grunt-tasks') grunt

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    watch:
      scripts:
        files: ['coffee/**/*.coffee']
        tasks: ['coffee']
      styles:
        files: ['scss/**/*.scss']
        tasks: ['sass']
    coffee:
      all:
        expand: true
        cwd: 'coffee'
        src: ['**/*.coffee'],
        dest: 'script',
        ext: '.js'
    sass:
      all:
        expand: true
        cwd: 'scss'
        src: ['**/*.scss'],
        dest: '.tmp',
        ext: '.css'
    concat:
      styles:
        files:
          'css/main.css': [
            '.tmp/main.css'
          ]
    #concurrent: # disabling it for now since it is so slow...
    #  all: ['coffee','sass']

  grunt.registerTask 'default', ['coffee','sass','concat:styles']
