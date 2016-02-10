module.exports = gulp = require('gulp')
$ = do require('gulp-load-plugins')
del = require('del')

gulp.task 'clean', ['clean:js', 'clean:css']
gulp.task 'clean:js', -> del ['js/**/*', 'js']
gulp.task 'clean:css', -> del ['css/**/*', 'css']

gulp.task 'compile', ['compile:coffee', 'compile:sass']
gulp.task 'compile:production', ['compile:coffee:production', 'compile:sass:production']

gulp.task 'compile:coffee', ->
  gulp.src 'coffee/**/*.coffee'
    .pipe $.plumber()
    .pipe $.sourcemaps.init()
    .pipe $.coffee
      bare: true
    .pipe $.uglify()
    .pipe $.sourcemaps.write()
    .pipe gulp.dest('js')

gulp.task 'compile:sass', ->
  gulp.src ['sass/**/*.scss', 'sass/**/*.sass']
    .pipe $.plumber()
    .pipe $.sourcemaps.init()
    .pipe $.sass()
    .pipe $.sourcemaps.write()
    .pipe gulp.dest('css')

gulp.task 'compile:coffee:production', ['clean:js'], ->
  gulp.src 'coffee/**/*.coffee'
    .pipe $.coffee
      bare: true
    .pipe $.uglify()
    .pipe gulp.dest('js')

gulp.task 'compile:sass:production', ['clean:css'], ->
  gulp.src ['sass/**/*.scss', 'sass/**/*.sass']
    .pipe $.sass()
    .pipe $.cssnano()
    .pipe gulp.dest('css')

gulp.task 'run', ['compile'], ->
  gulp.src '.'
    .pipe $.runElectron()
