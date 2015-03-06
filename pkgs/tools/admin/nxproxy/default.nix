{ fetchgit, stdenv, libxcomp, autoconf }:

stdenv.mkDerivation rec {
  name = "nxproxy";
  version = "3.5.0";

  src = fetchgit {
    url = "git://code.x2go.org/nx-libs.git";
    rev = "48e2c84f3396de62caa520a7385d3ae890216d7b";
    sha256 = "1df8cwn5nny44qcy6ip8rlibhd02v9813aqfpfdhiy0blb10r6ql";
  };


  buildInputs = [ libxcomp autoconf ];

  preConfigure = ''
    cd nxproxy/;
    autoconf;
  '';
  meta = {
    homepage = "http://code.x2go.org/gitweb?p=nx-libs.git;a=summary";
    license = stdenv.lib.licenses.gpl2;
    description = "NX compression proxy";
    platforms = stdenv.lib.platforms.linux;
  };
}