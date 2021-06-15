{ lib, stdenv, runCommand }:

let
  tests = {
    bad-shebang = stdenv.mkDerivation {
      name         = "bad-shebang";
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        echo "#!/bin/sh" > $out/bin/test
        echo "echo -n hello" >> $out/bin/test
        chmod +x $out/bin/test
      '';
      passthru = {
        assertion = "grep -v '^#!/bin/sh' $out/bin/test > /dev/null";
      };
    };

    ignores-nix-store = stdenv.mkDerivation {
      name = "ignores-nix-store";
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        echo "#!$NIX_STORE/path/to/sh" > $out/bin/test
        echo "echo -n hello" >> $out/bin/test
        chmod +x $out/bin/test
      '';
      passthru = {
        assertion = "grep \"^#!$NIX_STORE/path/to/sh\" $out/bin/test > /dev/null";
      };
    };
  };
in runCommand "patch-shebangs-test" {
  passthru = { inherit (tests) bad-shebang ignores-nix-store; };
  meta.platforms = lib.platforms.all;
} ''
  validate() {
    local name=$1
    local testout=$2
    local assertion=$3

    echo -n "... $name: " >&2

    local rc=0
    (out=$testout eval "$assertion") || rc=1

    if [ "$rc" -eq 0 ]; then
      echo "yes" >&2
    else
      echo "no" >&2
    fi

    return "$rc"
  }

  echo "checking whether patchShebangs works properly... ">&2

  fail=
  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (_: test: ''
    validate "${test.name}" "${test}" ${lib.escapeShellArg test.assertion} || fail=1
  '') tests)}

  if [ "$fail" ]; then
    echo "failed"
    exit 1
  else
    echo "succeeded"
    touch $out
  fi
''
