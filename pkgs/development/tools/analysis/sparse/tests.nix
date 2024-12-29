{ runCommand, gcc, sparse, writeText }:
let
  src = writeText "CODE.c" ''
    #include <stdio.h>
    #include <stddef.h>
    #include <stdlib.h>

    int main(int argc, char *argv[]) {
      return EXIT_SUCCESS;
    }
  '';
in
  runCommand "${sparse.pname}-tests" { buildInputs = [ gcc sparse ]; meta.timeout = 3; }
''
  set -eu
  ${sparse}/bin/cgcc ${src} > output 2>&1 || ret=$?
  if [[ -z $(<output) ]]; then
    mv output $out
  else
    echo "Test build returned $ret"
    cat output
    exit 1
  fi
''
