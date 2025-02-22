{
  lib,
  pkgs,
  stdenv,
}:

let
  inherit (lib.strings) concatStringsSep optionalString;
  inherit (pkgs) runCommand;
  inherit (pkgs.testers) testBuildFailure;

  mkDanglingSymlink = absolute: ''
    ln -s${optionalString (!absolute) "r"} "$out/dangling" "$out/dangling-symlink"
  '';

  mkReflexiveSymlink = absolute: ''
    ln -s${optionalString (!absolute) "r"} "$out/reflexive-symlink" "$out/reflexive-symlink"
  '';

  # Some platforms implement permissions for symlinks, while others - including
  # Linux - ignore them. This function takes an extra argument specifying
  # whether a failure to make the symlink unreadable should count as a 'fail' or
  # 'pass', to make sure the tests work properly for both kinds of platform.
  mkUnreadableSymlink = absolute: failIfUnsupported: ''
    touch "$out/unreadable-symlink-target"
    (
      umask 777
      ln -s${optionalString (!absolute) "r"} "$out/unreadable-symlink-target" "$out/unreadable-symlink"
    )
    if readlink "$out/unreadable-symlink" >/dev/null 2>&1; then
      nixErrorLog "symlink permissions not supported"
      ${optionalString failIfUnsupported "exit 1"}
    fi
  '';

  mkValidSymlink = absolute: ''
    touch "$out/valid"
    ln -s${optionalString (!absolute) "r"} "$out/valid" "$out/valid-symlink"
  '';

  mkValidSymlinkOutsideNixStore = absolute: ''
    ln -s${optionalString (!absolute) "r"} "/etc/my_file" "$out/valid-symlink"
  '';

  testBuilder =
    {
      name,
      commands ? [ ],
      derivationArgs ? { },
    }:
    stdenv.mkDerivation (
      {
        inherit name;
        strictDeps = true;
        dontUnpack = true;
        dontPatch = true;
        dontConfigure = true;
        dontBuild = true;
        installPhase =
          ''
            mkdir -p "$out"

          ''
          + concatStringsSep "\n" commands;
      }
      // derivationArgs
    );
in
{
  fail-dangling-symlink-relative =
    runCommand "fail-dangling-symlink-relative"
      {
        failed = testBuildFailure (testBuilder {
          name = "fail-dangling-symlink-relative-inner";
          commands = [ (mkDanglingSymlink false) ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        grep -F 'found 1 dangling symlinks, 0 reflexive symlinks and 0 unreadable symlinks' "$failed/testBuildFailure.log"
        touch $out
      '';

  pass-dangling-symlink-relative-allowed = testBuilder {
    name = "pass-dangling-symlink-relative-allowed";
    commands = [ (mkDanglingSymlink false) ];
    derivationArgs.dontCheckForBrokenSymlinks = true;
  };

  fail-dangling-symlink-absolute =
    runCommand "fail-dangling-symlink-absolute"
      {
        failed = testBuildFailure (testBuilder {
          name = "fail-dangling-symlink-absolute-inner";
          commands = [ (mkDanglingSymlink true) ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        grep -F 'found 1 dangling symlinks, 0 reflexive symlinks and 0 unreadable symlinks' "$failed/testBuildFailure.log"
        touch $out
      '';

  pass-dangling-symlink-absolute-allowed = testBuilder {
    name = "pass-dangling-symlink-absolute-allowed";
    commands = [ (mkDanglingSymlink true) ];
    derivationArgs.dontCheckForBrokenSymlinks = true;
  };

  fail-reflexive-symlink-relative =
    runCommand "fail-reflexive-symlink-relative"
      {
        failed = testBuildFailure (testBuilder {
          name = "fail-reflexive-symlink-relative-inner";
          commands = [ (mkReflexiveSymlink false) ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        grep -F 'found 0 dangling symlinks, 1 reflexive symlinks and 0 unreadable symlinks' "$failed/testBuildFailure.log"
        touch $out
      '';

  pass-reflexive-symlink-relative-allowed = testBuilder {
    name = "pass-reflexive-symlink-relative-allowed";
    commands = [ (mkReflexiveSymlink false) ];
    derivationArgs.dontCheckForBrokenSymlinks = true;
  };

  fail-reflexive-symlink-absolute =
    runCommand "fail-reflexive-symlink-absolute"
      {
        failed = testBuildFailure (testBuilder {
          name = "fail-reflexive-symlink-absolute-inner";
          commands = [ (mkReflexiveSymlink true) ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        grep -F 'found 0 dangling symlinks, 1 reflexive symlinks and 0 unreadable symlinks' "$failed/testBuildFailure.log"
        touch $out
      '';

  pass-reflexive-symlink-absolute-allowed = testBuilder {
    name = "pass-reflexive-symlink-absolute-allowed";
    commands = [ (mkReflexiveSymlink true) ];
    derivationArgs.dontCheckForBrokenSymlinks = true;
  };

  fail-unreadable-symlink-relative =
    runCommand "fail-unreadable-symlink-relative"
      {
        failed = testBuildFailure (testBuilder {
          name = "fail-unreadable-symlink-relative-inner";
          commands = [ (mkUnreadableSymlink false true) ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        grep -E 'found 0 dangling symlinks, 0 reflexive symlinks and 1 unreadable symlinks|symlink permissions not supported' "$failed/testBuildFailure.log"
        touch $out
      '';

  pass-unreadable-symlink-relative-allowed = testBuilder {
    name = "pass-unreadable-symlink-relative-allowed";
    commands = [ (mkUnreadableSymlink false false) ];
    derivationArgs.dontCheckForBrokenSymlinks = true;
  };

  fail-unreadable-symlink-absolute =
    runCommand "fail-unreadable-symlink-absolute"
      {
        failed = testBuildFailure (testBuilder {
          name = "fail-unreadable-symlink-absolute-inner";
          commands = [ (mkUnreadableSymlink true true) ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        grep -E 'found 0 dangling symlinks, 0 reflexive symlinks and 1 unreadable symlinks|symlink permissions not supported' "$failed/testBuildFailure.log"
        touch $out
      '';

  pass-unreadable-symlink-absolute-allowed = testBuilder {
    name = "pass-unreadable-symlink-absolute-allowed";
    commands = [ (mkUnreadableSymlink true false) ];
    derivationArgs.dontCheckForBrokenSymlinks = true;
  };

  fail-broken-symlinks-relative =
    runCommand "fail-broken-symlinks-relative"
      {
        failed = testBuildFailure (testBuilder {
          name = "fail-broken-symlinks-relative-inner";
          commands = [
            (mkDanglingSymlink false)
            (mkReflexiveSymlink false)
            (mkUnreadableSymlink false true)
          ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        if ! grep -F 'found 1 dangling symlinks, 1 reflexive symlinks and 1 unreadable symlinks' "$failed/testBuildFailure.log"; then
          grep -F 'symlink permissions not supported' "$failed/testBuildFailure.log"
          grep -F 'found 1 dangling symlinks, 1 reflexive symlinks and 0 unreadable symlinks' "$failed/testBuildFailure.log"
        fi
        touch $out
      '';

  pass-broken-symlinks-relative-allowed = testBuilder {
    name = "pass-broken-symlinks-relative-allowed";
    commands = [
      (mkDanglingSymlink false)
      (mkReflexiveSymlink false)
      (mkUnreadableSymlink false false)
    ];
    derivationArgs.dontCheckForBrokenSymlinks = true;
  };

  fail-broken-symlinks-absolute =
    runCommand "fail-broken-symlinks-absolute"
      {
        failed = testBuildFailure (testBuilder {
          name = "fail-broken-symlinks-absolute-inner";
          commands = [
            (mkDanglingSymlink true)
            (mkReflexiveSymlink true)
            (mkUnreadableSymlink true true)
          ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        if ! grep -F 'found 1 dangling symlinks, 1 reflexive symlinks and 1 unreadable symlinks' "$failed/testBuildFailure.log"; then
          grep -F 'symlink permissions not supported' "$failed/testBuildFailure.log"
          grep -F 'found 1 dangling symlinks, 1 reflexive symlinks and 0 unreadable symlinks' "$failed/testBuildFailure.log"
        fi
        touch $out
      '';

  pass-broken-symlinks-absolute-allowed = testBuilder {
    name = "pass-broken-symlinks-absolute-allowed";
    commands = [
      (mkDanglingSymlink true)
      (mkReflexiveSymlink true)
      (mkUnreadableSymlink true false)
    ];
    derivationArgs.dontCheckForBrokenSymlinks = true;
  };

  pass-valid-symlink-relative = testBuilder {
    name = "pass-valid-symlink-relative";
    commands = [ (mkValidSymlink false) ];
  };

  pass-valid-symlink-absolute = testBuilder {
    name = "pass-valid-symlink-absolute";
    commands = [ (mkValidSymlink true) ];
  };

  pass-valid-symlink-outside-nix-store-relative = testBuilder {
    name = "pass-valid-symlink-outside-nix-store-relative";
    commands = [ (mkValidSymlinkOutsideNixStore false) ];
  };

  pass-valid-symlink-outside-nix-store-absolute = testBuilder {
    name = "pass-valid-symlink-outside-nix-store-absolute";
    commands = [ (mkValidSymlinkOutsideNixStore true) ];
  };
}
