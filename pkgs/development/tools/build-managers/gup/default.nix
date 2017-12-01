{ stdenv, fetchFromGitHub, lib, python, which }:
let
  version = "0.7.0";
  src = fetchFromGitHub {
    sha256 = "1pwnmlq2pgkkln9sgz4wlb9dqlqw83bkf105qljnlvggc21zm3pv";
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
