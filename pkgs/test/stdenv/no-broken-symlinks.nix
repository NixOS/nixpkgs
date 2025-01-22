{
  lib,
  pkgs,
  stdenv,
}:

let
  inherit (lib.strings) concatStringsSep;
  inherit (pkgs) runCommand;
  inherit (pkgs.testers) testBuildFailure;

  mkDanglingSymlink = ''
    ln -sr "$out/dangling" "$out/dangling-symlink"
  '';

  mkReflexiveSymlink = ''
    ln -sr "$out/reflexive-symlink" "$out/reflexive-symlink"
  '';

  mkValidSymlink = ''
    touch "$out/valid"
    ln -sr "$out/valid" "$out/valid-symlink"
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
  # Dangling symlinks (allowDanglingSymlinks)
  fail-dangling-symlink =
    runCommand "fail-dangling-symlink"
      {
        failed = testBuildFailure (testBuilder {
          name = "fail-dangling-symlink-inner";
          commands = [ mkDanglingSymlink ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        grep -F 'found 1 dangling symlinks and 0 reflexive symlinks' "$failed/testBuildFailure.log"
        touch $out
      '';

  pass-dangling-symlink-allowed = testBuilder {
    name = "pass-symlink-dangling-allowed";
    commands = [ mkDanglingSymlink ];
    derivationArgs.allowDanglingSymlinks = true;
  };

  # Reflexive symlinks (allowReflexiveSymlinks)
  fail-reflexive-symlink =
    runCommand "fail-reflexive-symlink"
      {
        failed = testBuildFailure (testBuilder {
          name = "fail-reflexive-symlink-inner";
          commands = [ mkReflexiveSymlink ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        grep -F 'found 0 dangling symlinks and 1 reflexive symlinks' "$failed/testBuildFailure.log"
        touch $out
      '';

  pass-reflexive-symlink-allowed = testBuilder {
    name = "pass-reflexive-symlink-allowed";
    commands = [ mkReflexiveSymlink ];
    derivationArgs.allowReflexiveSymlinks = true;
  };

  # Global (dontCheckForBrokenSymlinks)
  fail-broken-symlinks =
    runCommand "fail-broken-symlinks"
      {
        failed = testBuildFailure (testBuilder {
          name = "fail-broken-symlinks-inner";
          commands = [
            mkDanglingSymlink
            mkReflexiveSymlink
          ];
        });
      }
      ''
        (( 1 == "$(cat "$failed/testBuildFailure.exit")" ))
        grep -F 'found 1 dangling symlinks and 1 reflexive symlinks' "$failed/testBuildFailure.log"
        touch $out
      '';

  pass-broken-symlinks-allowed = testBuilder {
    name = "fail-broken-symlinks-allowed";
    commands = [
      mkDanglingSymlink
      mkReflexiveSymlink
    ];
    derivationArgs.dontCheckForBrokenSymlinks = true;
  };

  pass-valid-symlink = testBuilder {
    name = "pass-valid-symlink";
    commands = [ mkValidSymlink ];
  };
}
