{ stdenv, fetchgit, lib, python, which }:
let
  version = "0.5.4";
  src = fetchgit {
    url = "https://github.com/gfxmonk/gup.git";
    rev = "b3980e529c860167b48e31634d2b479fc4d10274";
    sha256 = "bb02ba0a7f1680ed5b9a8e8c9cc42aa07016329840f397d914b94744f9ed7c85";
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
