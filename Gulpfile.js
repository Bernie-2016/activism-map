var gulp       = require('gulp');
var uglify     = require('gulp-uglify');
var concat     = require('gulp-concat');
var minifyCSS  = require('gulp-minify-css');
var copy       = require('gulp-copy');
var inline     = require('gulp-inline');
var minifyHTML = require('gulp-minify-html');
var connect    = require('gulp-connect');

gulp.task('css', function() {
  return gulp.src('css/**/*').pipe(concat('production.min.css')).pipe(minifyCSS({
    advanced: false
  })).pipe(gulp.dest('dist'));
});

gulp.task('cssDev', function() {
  return gulp.src('css/**/*').pipe(concat('production.min.css')).pipe(gulp.dest('dist'));
});

gulp.task('js', function() {
  return gulp.src(['node_modules/jquery/dist/jquery.js', 'node_modules/raphael/raphael.js', 'js/jquery.usmap.js', 'js/app.js']).pipe(concat('production.min.js')).pipe(uglify()).pipe(gulp.dest('dist'));
});

gulp.task('jsDev', function() {
  return gulp.src(['node_modules/jquery/dist/jquery.js', 'node_modules/raphael/raphael.js', 'js/jquery.usmap.js', 'js/app.js']).pipe(concat('production.min.js')).pipe(gulp.dest('dist'));
});

gulp.task('copy', function() {
  return gulp.src('index.html').pipe(copy('dist'));
});

gulp.task('inline', ['copy'], function() {
  return gulp.src('dist/index.html').pipe(inline()).pipe(minifyHTML()).pipe(gulp.dest('dist'));
});

gulp.task('watch', function() {
  gulp.watch(['index.html', 'js/**/*', 'css/**/*'], function(event) {
    return gulp.src(event.path).pipe(connect.reload());
  });
  gulp.watch('js/**/*', ['js']);
  gulp.watch('css/**/*', ['css']);
  return gulp.watch('index.html', ['copy']);
});

gulp.task('connect', function() {
  return connect.server({
    root: ['./dist'],
    port: 9010,
    livereload: {
      port: 32834
    },
    connect: {
      redirect: false
    }
  });
});

gulp.task('build', ['css', 'js', 'copy', 'inline']);
gulp.task('serve', ['cssDev', 'jsDev', 'copy', 'connect', 'watch']);
