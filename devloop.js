'use strict'

let compile = run({
  sh: 'stack build',
  watch: 'app/**'
})

let server = runServer({
  httpPort,
  env: { "PORT": httpPort },
  sh: `./.stack-work/install/x86_64-osx/lts-8.15/8.0.2/bin/cestpasnous`
}).dependsOn(compile)

proxy(server, 8080).dependsOn(compile)
