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

    dont-patch-builtins = stdenv.mkDerivation {
      name = "dont-patch-builtins";
      strictDeps = false;
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        echo "#!/usr/bin/builtin" > $out/bin/test
        chmod +x $out/bin/test
        dontPatchShebangs=
      '';
      passthru = {
        assertion = "grep '^#!/usr/bin/builtin' $out/bin/test > /dev/null";
      };
    };

    read-only-script =
      (derivation {
        name = "read-only-script";
        system = stdenv.buildPlatform.system;
        builder = "${stdenv.__bootPackages.stdenv.__bootPackages.bashNonInteractive}/bin/bash";
        initialPath = [
          stdenv.__bootPackages.stdenv.__bootPackages.coreutils
        ];
        strictDeps = false;
        args = [
          "-c"
          ''
            set -euo pipefail
            . ${../../stdenv/generic/setup.sh}
            . ${../../build-support/setup-hooks/patch-shebangs.sh}
            mkdir -p $out/bin
            echo "#!/bin/bash" > $out/bin/test
            echo "echo -n hello" >> $out/bin/test
            chmod 555 $out/bin/test
            patchShebangs $out/bin/test
          ''
        ];
        assertion = "grep '^#!${stdenv.shell}' $out/bin/test > /dev/null";
      })
      // {
        meta = { };
      };

    preserves-read-only =
      (derivation {
        name = "preserves-read-only";
        system = stdenv.buildPlatform.system;
        builder = "${stdenv.__bootPackages.stdenv.__bootPackages.bashNonInteractive}/bin/bash";
        initialPath = [
          stdenv.__bootPackages.stdenv.__bootPackages.coreutils
        ];
        strictDeps = false;
        args = [
          "-c"
          ''
            set -euo pipefail
            . ${../../stdenv/generic/setup.sh}
            . ${../../build-support/setup-hooks/patch-shebangs.sh}
            mkdir -p $out/bin
            echo "#!/bin/bash" > $out/bin/test
            echo "echo -n hello" >> $out/bin/test
            chmod 555 $out/bin/test
            original_perms=$(stat -c %a $out/bin/test)
            patchShebangs $out/bin/test
            new_perms=$(stat -c %a $out/bin/test)
            if ! [ "$original_perms" = "$new_perms" ]; then
              echo "Permissions changed from $original_perms to $new_perms"
              exit 1
            fi
          ''
        ];
        assertion = "grep '^#!${stdenv.shell}' $out/bin/test > /dev/null";
      })
      // {
        meta = { };
      };

    # Preserve times, see: https://github.com/NixOS/nixpkgs/pull/33281
    preserves-timestamp =
      (derivation {
        name = "preserves-timestamp";
        system = stdenv.buildPlatform.system;
        builder = "${stdenv.__bootPackages.stdenv.__bootPackages.bashNonInteractive}/bin/bash";
        initialPath = [
          stdenv.__bootPackages.stdenv.__bootPackages.coreutils
        ];
        strictDeps = false;
        args = [
          "-c"
          ''
            set -euo pipefail
            . ${../../stdenv/generic/setup.sh}
            . ${../../build-support/setup-hooks/patch-shebangs.sh}
            mkdir -p $out/bin
            echo "#!/bin/bash" > $out/bin/test
            echo "echo -n hello" >> $out/bin/test
            chmod +x $out/bin/test
            # Set a specific timestamp (2000-01-01 00:00:00)
            touch -t 200001010000 $out/bin/test
            original_timestamp=$(stat -c %Y $out/bin/test)
            patchShebangs $out/bin/test
            new_timestamp=$(stat -c %Y $out/bin/test)
            if ! [ "$original_timestamp" = "$new_timestamp" ]; then
              echo "Timestamp changed from $original_timestamp to $new_timestamp"
              exit 1
            fi
          ''
        ];
        assertion = "grep '^#!${stdenv.shell}' $out/bin/test > /dev/null";
      })
      // {
        meta = { };
      };

    preserves-binary-data =
      (derivation {
        name = "preserves-binary-data";
        system = stdenv.buildPlatform.system;
        builder = "${stdenv.__bootPackages.stdenv.__bootPackages.bashNonInteractive}/bin/bash";
        initialPath = [
          stdenv.__bootPackages.stdenv.__bootPackages.coreutils
        ];
        strictDeps = false;
        args = [
          "-c"
          ''
            set -euo pipefail
            . ${../../stdenv/generic/setup.sh}
            . ${../../build-support/setup-hooks/patch-shebangs.sh}
            mkdir -p $out/bin
            # Create a script with binary data after the shebang
            echo "#!/bin/bash" > $out/bin/test
            echo "echo 'script start'" >> $out/bin/test
            # Add some binary data (null bytes and other non-printable chars)
            printf '\x00\x01\x02\xff\xfe' >> $out/bin/test
            echo >> $out/bin/test
            echo "echo 'script end'" >> $out/bin/test
            chmod +x $out/bin/test
            patchShebangs $out/bin/test
            # Verify binary data is still present by checking file size and content
            if ! printf '\x00\x01\x02\xff\xfe' | cmp -s - <(sed -n '3p' $out/bin/test | tr -d '\n'); then
              echo "Binary data corrupted during patching"
              exit 1
            fi
          ''
        ];
        assertion = "grep '^#!${stdenv.shell}' $out/bin/test > /dev/null";
      })
      // {
        meta = { };
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
      dont-patch-builtins
      read-only-script
      preserves-read-only
      preserves-timestamp
      preserves-binary-data
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
