{ htop, expect, runCommand, writeScript, runtimeShell }:

let expect-script = writeScript "expect-script" ''
  #!${expect}/bin/expect -f

  exp_internal 1

  # Load htop
  spawn htop
  expect "Load average"

  # Load help (F1).
  send "\033OP"
  expect "htop ${htop.version}"
  send "q"

  # Filter processes.
  send "\\sleep 123"
  expect "sleep 123456"
  send "\n"

  send "k"
  expect "Send signal"
  send "\n"

  sleep 2
  send "q"
  expect eof
''; in
runCommand "htop-test-expect"
{
  nativeBuildInputs = [ htop expect ];
  passthru = { inherit expect-script; };
} ''
  # Process to manipulate.
  sleep 123456 &

  pid=$!
  expect -f ${expect-script}

  # Process should be killed.
  ! kill -0 $pid
  touch $out
''
