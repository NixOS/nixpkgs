{
  lib,
  stdenv,
  fetchurl,
  jre,
  writeScript,
  common-updater-scripts,
  git,
  nixfmt-classic,
  nix,
  coreutils,
  gnused,
  disableRemoteLogging ? true,
}:

let
  repo = "git@github.com:lihaoyi/Ammonite.git";

  common =
    { scalaVersion, sha256 }:
    stdenv.mkDerivation rec {
      pname = "ammonite";
      version = "3.0.0-M1";

      src = fetchurl {
        url = "https://github.com/lihaoyi/Ammonite/releases/download/${version}/${scalaVersion}-${version}";
        inherit sha256;
      };

      dontUnpack = true;

      installPhase =
        ''
          install -Dm755 $src $out/bin/amm
          sed -i '0,/java/{s|java|${jre}/bin/java|}' $out/bin/amm
        ''
        + lib.optionalString (disableRemoteLogging) ''
          sed -i "0,/ammonite.Main/{s|ammonite.Main'|ammonite.Main' --no-remote-logging|}" $out/bin/amm
          sed -i '1i #!/bin/sh' $out/bin/amm
        '';

      passthru = {

        updateScript = writeScript "update.sh" ''
          #!${stdenv.shell}
          set -o errexit
          PATH=${
            lib.makeBinPath [
              common-updater-scripts
              coreutils
              git
              gnused
              nix
              nixfmt-classic
            ]
          }
          oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion ${pname}" | tr -d '"')"
          latestTag="$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags ${repo} '*.*.*' | tail --lines=1 | cut --delimiter='/' --fields=3)"
          if [ "$oldVersion" != "$latestTag" ]; then
            nixpkgs="$(git rev-parse --show-toplevel)"
            default_nix="$nixpkgs/pkgs/development/tools/ammonite/default.nix"
            update-source-version ${pname}_2_12 "$latestTag" --version-key=version --print-changes
            sed -i "s|$latestTag|$oldVersion|g" "$default_nix"
            update-source-version ${pname}_2_13 "$latestTag" --version-key=version --print-changes
            nixfmt "$default_nix"
          else
            echo "${pname} is already up-to-date"
          fi
        '';
      };

      doInstallCheck = true;
      installCheckPhase = ''
        runHook preInstallCheck

        $out/bin/amm -h "$PWD" -c 'val foo = 21; println(foo * 2)' | grep 42

        runHook postInstallCheck
      '';

      meta = with lib; {
        description = "Improved Scala REPL";
        longDescription = ''
          The Ammonite-REPL is an improved Scala REPL, re-implemented from first principles.
          It is much more featureful than the default REPL and comes
          with a lot of ergonomic improvements and configurability
          that may be familiar to people coming from IDEs or other REPLs such as IPython or Zsh.
        '';
        homepage = "https://github.com/com-lihaoyi/Ammonite";
        license = licenses.mit;
        maintainers = [ maintainers.nequissimus ];
        mainProgram = "amm";
        platforms = platforms.all;
      };
    };
in
{
  ammonite_2_12 = common {
    scalaVersion = "2.12";
    sha256 = "sha256-SlweOVHudknbInM4rfEPJ9bLd3Z/EImLhVLzeKfjfMQ=";
  };
  ammonite_2_13 = common {
    scalaVersion = "2.13";
    sha256 = "sha256-2BydXmF6AkWDdG5rbRLD2I/6z3w3UD0dCd5Tp+3lU7c=";
  };
}
