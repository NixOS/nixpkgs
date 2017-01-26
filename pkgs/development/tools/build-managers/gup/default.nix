{ stdenv, fetchFromGitHub, lib, pythonPackages, nix-update-source, curl }:
import ./build.nix
  { inherit stdenv lib pythonPackages; }
  { inherit (nix-update-source.fetch ./src.json) src version;
    meta = {
      homepage = https://github.com/timbertson/gup/;
      description = "A better make, inspired by djb's redo";
      license = stdenv.lib.licenses.lgpl2Plus;
      maintainers = [ stdenv.lib.maintainers.timbertson ];
      platforms = stdenv.lib.platforms.all;
    };
    passthru = {
      updateScript = ''
        set -e
        echo
        cd ${toString ./.}
        ${nix-update-source}/bin/nix-update-source --prompt version src.json
        ./build.nix.gup build.nix
      '';
    };
  }
