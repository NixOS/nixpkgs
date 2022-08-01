{ runCommand, jprofiler }:

runCommand "jprofiler-test-run" {
  nativeBuildInputs = [ jprofiler ];
} ''
  diff -U3 --color=auto <((jpcontroller -n -f /dev/null 2>&1 || true) | head -n 1 ) <(echo 'No profiled JVMs found.')
  touch $out
''
