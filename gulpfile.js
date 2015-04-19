'use strict';
var gulp       = require('gulp'),
    coffee     = require('gulp-coffee'),
    es         = require('event-stream'),
    browserify = require('browserify'),
    source     = require('vinyl-source-stream');

var BUILD_FILES = [
  'content.js',
  'background.js'
];


gulp.task('default', [
  'build'
]);

gulp.task('coffee', function(){
  return gulp.src('src/**/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('tmp/js'));
});

gulp.task('browserify', ['coffee'], function(){
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

gulp.task('build', ['browserify', 'manifest']);
gulp.task('watch', ['build'], function(){
  gulp.watch('src/**/*.coffee', ['browserify']);
  gulp.watch('src/manifest.json', ['manifest']);
});
