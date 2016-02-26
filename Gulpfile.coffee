gulp       = require 'gulp'
uglify     = require 'gulp-uglify'
concat     = require 'gulp-concat'
minifyCSS  = require 'gulp-minify-css'
copy       = require 'gulp-copy'
inline     = require 'gulp-inline'
minifyHTML = require 'gulp-minify-html'
connect    = require 'gulp-connect'

gulp.task 'css', ->
  gulp.src('css/**/*')
    .pipe(concat('production.min.css'))
    .pipe(minifyCSS(advanced: false))
    .pipe(gulp.dest('dist'))

gulp.task 'cssDev', ->
  gulp.src('css/**/*')
    .pipe(concat('production.min.css'))
    .pipe(gulp.dest('dist'))

gulp.task 'js', ->
  gulp.src([
    'node_modules/jquery/dist/jquery.js'
    'node_modules/raphael/raphael.js'
    'js/jquery.usmap.js'
    'js/app.js'
  ]).pipe(concat('production.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest('dist'))

gulp.task 'jsDev', ->
  gulp.src([
    'node_modules/jquery/dist/jquery.js'
    'node_modules/raphael/raphael.js'
    'js/jquery.usmap.js'
    'js/app.js'
  ]).pipe(concat('production.min.js'))
    .pipe(gulp.dest('dist'))

gulp.task 'copy', ->
  gulp.src('index.html')
    .pipe(copy('dist'))

gulp.task 'inline', ['copy'], ->
  gulp.src('dist/index.html')
    .pipe(inline())
    .pipe(minifyHTML())
    .pipe(gulp.dest('dist'))

gulp.task 'watch', ->
  gulp.watch [
    'index.html'
    'js/**/*'
    'css/**/*'
  ], (event) ->
    gulp.src(event.path)
      .pipe(connect.reload())

  gulp.watch 'js/**/*', ['js']
  gulp.watch 'css/**/*', ['css']
  gulp.watch 'index.html', ['copy']

gulp.task 'connect', ->
  connect.server
    root: ['./dist']
    port: 9010
    livereload:
      port: 32834
    connect:
      redirect: false

gulp.task 'build', [
  'css'
  'js'
  'copy'
  'inline'
]

gulp.task 'serve', [
  'cssDev'
  'jsDev'
  'copy'
  'connect'
  'watch'
]
