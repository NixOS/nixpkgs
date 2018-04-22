{ stdenv, fetchFromGitHub, lib, python, which, pychecker ? null }:
stdenv.mkDerivation rec {
  version = "0.7.0";
  src = fetchFromGitHub {
    sha256 = "1pwnmlq2pgkkln9sgz4wlb9dqlqw83bkf105qljnlvggc21zm3pv";
    rev = "version-${version}";
    repo = "gup";
    owner = "timbertson";
  };
  name = "gup-${version}";
  buildInputs = lib.remove null [ python which pychecker ];
  SKIP_PYCHECKER = pychecker == null;
  buildPhase = "make python";
  installPhase = ''
    mkdir $out
    cp -r python/bin $out/bin
  '';
  meta = {
    inherit (src.meta) homepage;
    description = "A better make, inspired by djb's redo";
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ stdenv.lib.maintainers.timbertson ];
    platforms = stdenv.lib.platforms.all;
  };
}
