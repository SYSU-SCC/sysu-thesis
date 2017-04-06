const gulp = require('gulp')
const shell = require('gulp-shell')
// var browserSync = require('browser-sync');
// var reload = browserSync.reload;

// 监视文件改动并重新载入
// gulp.task('serve', function() {
//   browserSync({
//     server: {
//       baseDir: '.',
//       middleware: [{
//         route: "/",
//         handle: (req, res, next) => {
//           res.writeHead(302,  { 'Location': '/main.pdf' })                                                                                                                                                                
//           res.end()
//           next()
//         }
//       }]
//     }
//   });
// 
//   gulp.watch(['main.pdf'], reload);
// });

// gulp.task('build', buildThesis);
gulp.task('build', shell.task('make'))

gulp.task('watch', function() {
  gulp.watch(['./**/*.tex', './**/*.cls'], ['build']);
})

gulp.task('default', ['build', 'watch']);

// function buildThesis() {
//   const spawn = require('child_process').spawn;
//   const buildThesis = spawn('make.exe');
//   
//   buildThesis.stdout.on('data', (data) => {
//     console.log(`stdout: ${data}`);
//   });
//   
//   buildThesis.stderr.on('data', (data) => {
//     console.log(`stderr: ${data}`);
//   });
//   
//   buildThesis.on('close', (code) => {
//     console.log(`child process exited with code ${code}`);
//   });
// }