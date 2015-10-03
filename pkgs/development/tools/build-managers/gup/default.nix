{ stdenv, fetchgit, lib, python, which }:
let
  version = "0.5.1";
  src = fetchgit {
    url = "https://github.com/gfxmonk/gup.git";
    rev = "f185052e2177ed5e46720e6c6cfb529b96cd17e2";
    sha256 = "c2e27cdba2231017ceb4868f58f5c3b224be0491b81558b4e59bb08a952ad1a5";
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
