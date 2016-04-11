{ stdenv, fetchFromGitHub, lib, python, which }:
let
  version = "0.5.5";
  src = fetchFromGitHub {
    sha256 = "12yv0j333z6jkaaal8my3jx3k4ml9hq8ldis5zfvr8179d4xah7q";
    rev = "version-${version}";
    repo = "gup";
    owner = "gfxmonk";
  };
in
import ./build.nix
  { inherit stdenv lib python which; }
  { inherit src version;
    meta = {
      description = "A better make, inspired by djb's redo";
      homepage = https://github.com/gfxmonk/gup;
      license = stdenv.lib.licenses.lgpl2Plus;
      maintainers = [ stdenv.lib.maintainers.gfxmonk ];
      platforms = stdenv.lib.platforms.all;
    };
  }
