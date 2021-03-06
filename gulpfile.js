/**
 * @file gulpfile.js
 * @author xieyu03@baidu.com
 */
var usemin = require('gulp-usemin');
var gulp = require('gulp');
var riot = require('gulp-riot');
var concat = require('gulp-concat');
var minifyCSS = require('gulp-minify-css');
var minifyHtml = require('gulp-minify-html');
var uglify = require('gulp-uglify');
var rev = require('gulp-rev');
var connect = require('gulp-connect');
var fs = require('fs');
var webpack = require('webpack-stream');
var del  = require('del');
var less = require('gulp-less');


if (!fs.existsSync('./dev/config.js')) {
    fs.writeFileSync('./dev/config.js', fs.readFileSync('./dev/config.example.js'));
}
var config = require('./dev/config');

gulp.task('riotAndroid', [], function() {
    return gulp.src(['src/js/tags-dep.js','src/tags/common/*.tag', 'src/tags/order/**/*.tag','src/tags/shop/**/*.tag','src/tags/account/register/*.tag'])
        .pipe(riot())
        .pipe(concat('tags.js'))
        .pipe(gulp.dest('src/js'));
});

gulp.task('webpackAndroid', ['riotAndroid'], function() {
    return gulp.src('src/js/boot.js')
        .pipe(webpack(require('./webpack.config.js')))
        .pipe(gulp.dest('src'))
        .pipe(connect.reload());
});

gulp.task('lessAndroid', [], function() {
    return gulp.src(['src/css/*.css', 'src/less/*.less', 'src/less/common/*.less', 'src/less/login/*.less', 'src/less/order/**/*.less', 'src/less/shop/**/*.less', 'src/less/static/**/*.less'])
        .pipe(less())
        .pipe(concat('bundle.css'))
        .pipe(gulp.dest('src'));
});

gulp.task('riot', [], function() {
    return gulp.src(['src/js/tags-dep.js', 'src/tags/*.tag', 'src/tags/*/*.tag', 'src/tags/*/*/*.tag', 'src/tags/*/*/*/*.tag'])
        .pipe(riot())
        .pipe(concat('tags.js'))
        .pipe(gulp.dest('src/js'));
});

gulp.task('webpack', ['riot'], function() {
    return gulp.src('src/js/boot.js')
        .pipe(webpack(require('./webpack.config.js')))
        .pipe(gulp.dest('src'))
        .pipe(connect.reload());
});

gulp.task('less', [], function() {
    return gulp.src(['src/css/*.css', 'src/less/*.less', 'src/less/*/*.less', 'src/css/*/*/*.less'])
        .pipe(less())
        .pipe(concat('bundle.css'))
        .pipe(gulp.dest('src'));
});


/*
 * 清空dist目录
 */
gulp.task('clean', function() {
    return del(['dist/imgs','dist/static', 'dist']);
});

/*
 * 拷贝 src/imgs 中的图片到 dist/imgs
 */
gulp.task('move', ['clean'], function() {
    return gulp.src('./src/imgs/*').pipe(gulp.dest('dist/imgs'));
});
gulp.task('static', ['clean'], function() {
    return gulp.src('./src/static/**').pipe(gulp.dest('dist/static'));
});

gulp.task('online', ['clean', 'webpackAndroid', 'lessAndroid', 'move', 'static'], function() {
    return gulp.src('./src/android.html')
        .pipe(usemin({
            css: [ minifyCSS, rev ],
            html: [ function () {return minifyHtml({ empty: true });} ],
            js: [ uglify, rev ],
            inlinejs: [ uglify ],
            inlinecss: [ minifyCSS, 'concat' ]
        }))
        .pipe(gulp.dest('dist/'));
});

gulp.task('dist', ['clean', 'webpack', 'less', 'move', 'static'], function() {
    return gulp.src('./src/*.html')
        .pipe(usemin({
            css: [ minifyCSS, rev ],
            html: [ function () {return minifyHtml({ empty: true });} ],
            js: [ uglify, rev ],
            inlinejs: [ uglify ],
            inlinecss: [ minifyCSS, 'concat' ]
        }))
        .pipe(gulp.dest('dist/'));
});

gulp.task('run', ['online'], function() {
    connect.server({
        root: 'src',
        livereload: {
            port: config.project.liveReloadPort,
            src: 'http://localhost:' + config.project.liveReloadPort + '/livereload.js?snipver=1'
        },
        port: config.project.port
    });
    gulp.watch(['src/less/*', 'src/less/*/*','src/less/*/*/*'], ['lessAndroid'], function() {
        return gulp.src('.').pipe(connect.reload());
    });
    return gulp.watch(['src/tags/*.tag', 'src/tags/*/*.tag','src/tags/*/*/*.tag', 'src/tags/*/*/*/*.tag', 'src/js/*.js'], ['webpackAndroid'], function(){
        return gulp.src('.').pipe(connect.reload());
    });
});

gulp.task('default', ['dist'], function() {
    connect.server({
        root: 'src',
        livereload: {
            port: config.project.liveReloadPort,
            src: 'http://localhost:' + config.project.liveReloadPort + '/livereload.js?snipver=1'
        },
        port: config.project.port
    });
    gulp.watch(['src/less/*', 'src/less/*/*','src/less/*/*/*'], ['less'], function() {
        return gulp.src('.').pipe(connect.reload());
    });
    return gulp.watch(['src/tags/*.tag', 'src/tags/*/*.tag','src/tags/*/*/*.tag', 'src/tags/*/*/*/*.tag', 'src/js/*.js'], ['webpack'], function(){
        return gulp.src('.').pipe(connect.reload());
    });
});
