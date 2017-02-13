{ stdenv, fetchFromGitHub, lib, python, which }:
let
  version = "0.6.0";
  src = fetchFromGitHub {
    sha256 = "053xnx39jh9kn9l572z4k0q7bbxjpisf1fm9aq27ybj2ha1rh6wr";
    rev = "version-${version}";
    repo = "gup";
    owner = "timbertson";
  };
in
import ./build.nix
  { inherit stdenv lib python which; }
  { inherit src version;
    meta = {
      inherit (src.meta) homepage;
      description = "A better make, inspired by djb's redo";
      license = stdenv.lib.licenses.lgpl2Plus;
      maintainers = [ stdenv.lib.maintainers.timbertson ];
      platforms = stdenv.lib.platforms.all;
    };
  }
