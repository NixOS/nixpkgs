{ stdenv, fetchgit, lib, python, which }:
let
  version = "0.5.3";
  src = fetchgit {
    url = "https://github.com/gfxmonk/gup.git";
    rev = "55ffd8828ddc28a2a786b75422d672d6569f961f";
    sha256 = "7c2abbf5d3814c6b84da0de1c91f9f7d299c2362cf091da96f6a68d8fffcb5ce";
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
