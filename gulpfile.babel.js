'use strict';
var gulp       = require('gulp'),
    coffee     = require('gulp-coffee'),
    babel      = require('gulp-babel'),
    es         = require('event-stream'),
    babelify   = require('babelify'),
    browserify = require('browserify'),
    source     = require('vinyl-source-stream'),
    zip        = require('gulp-zip');

var BUILD_FILES = [
  'content.js',
  'background.js',
  'album.js'
];


gulp.task('default', [
  'build'
]);

gulp.task('coffee', function(){
  return gulp.src('src/**/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('tmp/js'));
});

gulp.task('es6', function(){
  return gulp.src('src/**/*.js')
    .pipe(gulp.dest('tmp/js'));
});

gulp.task('html', function(){
  return gulp.src('src/**/*.html')
    .pipe(gulp.dest('app/'));
});

gulp.task('browserify', ['coffee', 'es6'], function(){
  return es.merge.apply(es, BUILD_FILES.map(function(path){
    return browserify('./tmp/js/' + path)
      .transform(babelify, {presets: ['es2015', 'react']})
      .bundle()
      .pipe(source(path))
      .pipe(gulp.dest('app/js'));
  }));
});

gulp.task('manifest', function(){
  return gulp.src('src/manifest.json')
    .pipe(gulp.dest('app/'));
});

gulp.task('zip', ['build'], function(){
  return gulp.src('app/**/*')
    .pipe(zip('lgtmize.zip'))
    .pipe(gulp.dest('build'));
});

gulp.task('build', ['browserify', 'manifest', 'html']);
gulp.task('watch', ['build'], function(){
  gulp.watch('src/**/*.coffee', ['browserify']);
  gulp.watch('src/**/*.es6', ['browserify']);
  gulp.watch('src/manifest.json', ['manifest']);
  gulp.watch('src/**/*.html', ['html']);
});
