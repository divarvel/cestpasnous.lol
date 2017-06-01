'use strict'

let compile = run({
  sh: 'stack build',
  watch: '*.hs'
})

let server = runServer({
  httpPort,
  env: { "PORT": httpPort },
  sh: `./.stack-work/install/*/*/*/bin/cestpasnous`
}).dependsOn(compile)

proxy(server, 8080).dependsOn(compile)
