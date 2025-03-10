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
        grep -F 'found 1 dangling symlinks and 0 reflexive symlinks' "$failed/testBuildFailure.log"
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
        grep -F 'found 1 dangling symlinks and 0 reflexive symlinks' "$failed/testBuildFailure.log"
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
        grep -F 'found 0 dangling symlinks and 1 reflexive symlinks' "$failed/testBuildFailure.log"
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
        grep -F 'found 0 dangling symlinks and 1 reflexive symlinks' "$failed/testBuildFailure.log"
        touch $out
      '';

  pass-reflexive-symlink-absolute-allowed = testBuilder {
    name = "pass-reflexive-symlink-absolute-allowed";
    commands = [ (mkReflexiveSymlink true) ];
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
          ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        grep -F 'found 1 dangling symlinks and 1 reflexive symlinks' "$failed/testBuildFailure.log"
        touch $out
      '';

  pass-broken-symlinks-relative-allowed = testBuilder {
    name = "pass-broken-symlinks-relative-allowed";
    commands = [
      (mkDanglingSymlink false)
      (mkReflexiveSymlink false)
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
          ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        grep -F 'found 1 dangling symlinks and 1 reflexive symlinks' "$failed/testBuildFailure.log"
        touch $out
      '';

  pass-broken-symlinks-absolute-allowed = testBuilder {
    name = "pass-broken-symlinks-absolute-allowed";
    commands = [
      (mkDanglingSymlink true)
      (mkReflexiveSymlink true)
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
