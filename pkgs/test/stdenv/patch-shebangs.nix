{
  lib,
  stdenv,
  pkgs,
}:

# since the tests are using a early stdenv, the stdenv will have dontPatchShebangs=1, so it has to be unset
# https://github.com/NixOS/nixpkgs/blob/768a982bfc9d29a6bd3beb963ed4b054451ce3d0/pkgs/stdenv/linux/default.nix#L148-L153

# strictDeps has to be disabled because the shell isn't in buildInputs

let
  tests = {
    bad-shebang = stdenv.mkDerivation {
      name = "bad-shebang";
      strictDeps = false;
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        echo "#!/bin/bash" > $out/bin/test
        echo "echo -n hello" >> $out/bin/test
        chmod +x $out/bin/test
        dontPatchShebangs=
      '';
      passthru = {
        assertion = "grep '^#!${stdenv.shell}' $out/bin/test > /dev/null";
      };
    };

    ignores-nix-store = stdenv.mkDerivation {
      name = "ignores-nix-store";
      strictDeps = false;
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        echo "#!$NIX_STORE/path/to/bash" > $out/bin/test
        echo "echo -n hello" >> $out/bin/test
        chmod +x $out/bin/test
        dontPatchShebangs=
      '';
      passthru = {
        assertion = "grep \"^#!$NIX_STORE/path/to/bash\" $out/bin/test > /dev/null";
      };
    };

    updates-nix-store = stdenv.mkDerivation {
      name = "updates-nix-store";
      strictDeps = false;
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        echo "#!$NIX_STORE/path/to/bash" > $out/bin/test
        echo "echo -n hello" >> $out/bin/test
        chmod +x $out/bin/test
        patchShebangs --update $out/bin/test
        dontPatchShebangs=1
      '';
      passthru = {
        assertion = "grep '^#!${stdenv.shell}' $out/bin/test > /dev/null";
      };
    };

    split-string = stdenv.mkDerivation {
      name = "split-string";
      strictDeps = false;
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        echo "#!/usr/bin/env -S bash --posix" > $out/bin/test
        echo "echo -n hello" >> $out/bin/test
        chmod +x $out/bin/test
        dontPatchShebangs=
      '';
      passthru = {
        assertion = "grep -v '^#!${pkgs.coreutils}/bin/env -S ${stdenv.shell} --posix' $out/bin/test > /dev/null";
      };
    };

    without-trailing-newline = stdenv.mkDerivation {
      name = "without-trailing-newline";
      strictDeps = false;
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        printf "#!/bin/bash" > $out/bin/test
        chmod +x $out/bin/test
        dontPatchShebangs=
      '';
      passthru = {
        assertion = "grep '^#!${stdenv.shell}' $out/bin/test > /dev/null";
      };
    };

  };
in
stdenv.mkDerivation {
  name = "test-patch-shebangs";
  passthru = {
    inherit (tests)
      bad-shebang
      ignores-nix-store
      updates-nix-store
      split-string
      without-trailing-newline
      ;
  };
  buildCommand = ''
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
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (_: test: ''
        validate "${test.name}" "${test}" ${lib.escapeShellArg test.assertion} || fail=1
      '') tests
    )}

    if [ "$fail" ]; then
      echo "failed"
      exit 1
    else
      echo "succeeded"
      touch $out
    fi
  '';
}
