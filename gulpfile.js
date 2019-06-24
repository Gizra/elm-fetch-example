const Bundler = require('parcel-bundler');
const Path = require('path');
const browserSync = require('browser-sync');
const del = require('del');
const ghPages = require('gh-pages');
const gulp = require('gulp');
const gulpSequence = require('gulp-sequence');

const entry = Path.join(__dirname, './src/index.html');

const parcelDevOptions = {
    outDir: './serve',
    watch: false,
    cache: true,
    cacheDir: '.cache',
    contentHash: false,
    minify: false,
    hmr: false,
    sourceMaps: true,
    production: true
};

const parcelWatchOptions = {
    outDir: './serve',
    watch: true,
    cache: true,
    cacheDir: '.cache',
    contentHash: false,
    minify: false,
    hmr: false,
    sourceMaps: true,
    production: true
};

// contentHash is false because we want a stable reference to use
// in the Powtoown CMS. The files still have a hash, but it is a
// stable hash -- doesn't change when the contents change.
const parcelProdOptions = {
    outDir: './dist',
    watch: false,
    cache: true,
    cacheDir: '.cache',
    contentHash: false,
    // @todo: Change this to `true` when debugging is not needed anymore.
    minify: false,
    hmr: false,
    sourceMaps: false,
    production: true
};

// Deletes the directory that is used to serve the site during development
gulp.task('clean:dev', function(cb) {
    return del(['serve'], cb);
});

// Deletes the directory that is used in production builds.
gulp.task('clean:prod', function(cb) {
    return del(['dist'], cb);
});

// Starts a webserver and watches source files for changes.
gulp.task('serve:dev', ['clean:dev'], function() {
    const bundler = new Bundler(entry, parcelWatchOptions);
    bundler.bundle().then(() => {
        browserSync({
            notify: true,
            watch: true,
            server: {
                baseDir: 'serve'
            }
        });
    });
});

// Builds the site but doesn't serve it to you
gulp.task('build:dev', ['clean:dev'], function() {
    const bundler = new Bundler(entry, parcelDevOptions);

    return bundler.bundle();
});

// Builds the site but doesn't serve it to you
gulp.task('build:prod', function() {
    const bundler = new Bundler(entry, parcelProdOptions);

    return bundler.bundle();
});

// Copy CNAME file to the "dist" directory
gulp.task('copy:prod', function () {
    return gulp.src(['./src/CNAME'])
      .pipe(gulp.dest('./dist'));
});

gulp.task('publish:prod', function (cb) {
   ghPages.publish('dist', cb);
});

// Publish to gh-pages
gulp.task('publish', gulpSequence('clean:prod', 'copy:prod', 'build:prod', 'publish:prod'));

// Default task, run when just writing "gulp" in the terminal
gulp.task('default', ['serve:dev']);
