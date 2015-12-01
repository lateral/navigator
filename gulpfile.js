'use strict';

var argv = require('minimist')(process.argv.slice(2));
var browserify = require('browserify');
var fs = require('fs');
var gulp = require('gulp');
var del = require('del');
var $ = require('gulp-load-plugins')();
var browserSync = require('browser-sync');
var webpack = require('webpack');
var webpackStream = require('webpack-stream');
var stripAnsi = require('strip-ansi');

// Minimize and optimize during a build?
var RELEASE = !!argv.release;

// Set up some paths for configuration
var src    = 'app';
var target = 'public';

// Define the asset paths
var paths = {
  main:      src + '/assets/scripts/application.js',
  mainGlob: [src + '/assets/scripts/**/*.{js,hbs}'],

  templates: src + '/assets/scripts/templates/**/*.hbs',
  styles:    src + '/assets/styles/**/*.scss',
  stylesDir: src + '/assets/styles',
  images:    src + '/assets/images/**',
  other:    [src + '/assets/*.{ico,txt}', src + '/views/*.html']
};

var onError = function(err) {
  err.message = stripAnsi(err.message);
  $.notify.onError({
    title: 'Gulp',
    subtitle: 'Error',
    message: '<%= error.message %>',
    sound: false
  })(err);
  this.emit('end');
};

gulp.task('clean', function(cb) { del([target + '/**/*'], cb); });

gulp.task('bundle', function(cb) {
  return gulp.src(paths.main)
    .pipe($.plumber({ errorHandler: onError }))
    .pipe(webpackStream({
      output: { filename: 'app.js' },
      module: { loaders: [{ test: /\.hbs$/, loader: 'handlebars-loader' }] },
      plugins: [
        new webpack.ProvidePlugin({
          $: 'jquery',
          jQuery: 'jquery',
          _: 'underscore',
          Backbone: 'backbone',
          'Backbone.Marionette': 'backbone.marionette',
          Handlebars: 'handlebars'
        })
      ],
      debug: !!RELEASE
    }))
    .pipe($.if(RELEASE, $.uglify()))
    .pipe(gulp.dest(target))
    .pipe(browserSync.stream());
});

// Compiles SASS using compass
gulp.task('compass', function() {
  del(['tmp/.css/**/*']);
  return gulp.src(paths.styles)
    .pipe($.plumber({ errorHandler: onError }))
    .pipe($.compass({ css: 'tmp/.css', sass: paths.stylesDir, require: ['sass-globbing'] }))
    .pipe($.if(RELEASE, $.minifyCss()))
    .pipe(gulp.dest(target))
    .pipe(browserSync.stream());
});

// Copies all static images to extension folder
gulp.task('images', function() {
  return gulp.src(paths.images, { base: src + '/assets' })
    .pipe($.plumber({ errorHandler: onError }))
    .pipe($.if(RELEASE, $.imagemin({ optimizationLevel: 5 })))
    .pipe(gulp.dest(target));
});

// Copies static assets to the extension folder
gulp.task('copy', function() {
  return gulp.src(paths.other)
    .pipe($.plumber({ errorHandler: onError }))
    .pipe(gulp.dest(target));
});

// use default task to launch Browsersync and watch JS files
gulp.task('browserSync', function() {
  browserSync({
    open: false,
    proxy: 'localhost:4000',
    ui: false
  });
});

// Rerun the tasks when files changes
gulp.task('watch', function() {
  gulp.watch(paths.mainGlob, ['bundle']);
  gulp.watch(paths.other, ['copy']).on('change', browserSync.reload);
  gulp.watch(paths.styles, ['compass']);
  gulp.watch(paths.images, ['images']).on('change', browserSync.reload);
});

// Build
gulp.task('build', [
  'clean', 'bundle', 'compass', 'copy', 'images'
]);

// Default performs all tasks and watches
gulp.task('default', [
  'build', 'watch', 'browserSync'
]);
