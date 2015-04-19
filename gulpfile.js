'use strict';
var gulp       = require('gulp'),
    coffee     = require('gulp-coffee'),
    cjsx       = require('gulp-cjsx'),
    es         = require('event-stream'),
    browserify = require('browserify'),
    source     = require('vinyl-source-stream');

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

gulp.task('cjsx', function(){
  return gulp.src('src/**/*.cjsx')
    .pipe(cjsx())
    .pipe(gulp.dest('tmp/js'));
});

gulp.task('html', function(){
  return gulp.src('src/**/*.html')
    .pipe(gulp.dest('app/'));
});

gulp.task('browserify', ['coffee', 'cjsx'], function(){
  return es.merge.apply(es, BUILD_FILES.map(function(path){
    return browserify('./tmp/js/' + path)
      .bundle()
      .pipe(source(path))
      .pipe(gulp.dest('app/js'));
  }));
});

gulp.task('manifest', function(){
  return gulp.src('src/manifest.json')
    .pipe(gulp.dest('app/'));
});

gulp.task('build', ['browserify', 'manifest', 'html']);
gulp.task('watch', ['build'], function(){
  gulp.watch('src/**/*.coffee', ['browserify']);
  gulp.watch('src/**/*.cjsx', ['browserify']);
  gulp.watch('src/manifest.json', ['manifest']);
  gulp.watch('src/**/*.html', ['html']);
});
