{ lib, stdenv, fetchurl, jre, nixosTests, writeScript, common-updater-scripts
, git, nixfmt, nix, coreutils, gnused, disableRemoteLogging ? true }:

with lib;

let
  repo = "git@github.com:lihaoyi/Ammonite.git";

  common = { scalaVersion, sha256 }:
    stdenv.mkDerivation rec {
      pname = "ammonite";
      version = "2.4.0";

      src = fetchurl {
        url =
          "https://github.com/lihaoyi/Ammonite/releases/download/${version}/${scalaVersion}-${version}";
        inherit sha256;
      };

      dontUnpack = true;

      installPhase = ''
        install -Dm755 $src $out/bin/amm
        sed -i '0,/java/{s|java|${jre}/bin/java|}' $out/bin/amm
      '' + optionalString (disableRemoteLogging) ''
        sed -i "0,/ammonite.Main/{s|ammonite.Main'|ammonite.Main' --no-remote-logging|}" $out/bin/amm
        sed -i '1i #!/bin/sh' $out/bin/amm
      '';

      passthru = {
        tests = { inherit (nixosTests) ammonite; };

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
              nixfmt
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

      meta = {
        description = "Improved Scala REPL";
        longDescription = ''
          The Ammonite-REPL is an improved Scala REPL, re-implemented from first principles.
          It is much more featureful than the default REPL and comes
          with a lot of ergonomic improvements and configurability
          that may be familiar to people coming from IDEs or other REPLs such as IPython or Zsh.
        '';
        homepage = "https://www.lihaoyi.com/Ammonite/";
        license = licenses.mit;
        platforms = platforms.all;
        maintainers = [ maintainers.nequissimus ];
      };
    };
in {
  ammonite_2_12 = common {
    scalaVersion = "2.12";
    sha256 = "K8JII6SAmnBjMWQ9a3NqSLLuP1OLcbwobj3G+OCiLdA=";
  };
  ammonite_2_13 = common {
    scalaVersion = "2.13";
    sha256 = "2F35qhWI6hNb+Eh9ZTDznqo116yN7MZIGVchaAIM36A=";
  };
}
