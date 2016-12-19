{ stdenv, fetchFromGitHub, tcl }:

stdenv.mkDerivation rec {
  name = "eggdrop-${version}";
  version = "1.6.21-nix1";

  src = fetchFromGitHub {
    owner = "eggheads";
    repo = "eggdrop";
    rev = "9ec109a13c016c4cdc7d52b7e16e4b9b6fbb9331";
    sha256 = "0mf1vcbmpnvmf5mxk7gi3z32fxpcbynsh9jni8z8frrscrdf5lp5";
  };

  buildInputs = [ tcl ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    prefix=$out/eggdrop
    mkdir -p $prefix
  '';

  postConfigure = ''
    make config
  '';

  configureFlags = [
    "--with-tcllib=${tcl}/lib/lib${tcl.libPrefix}.so"
    "--with-tclinc=${tcl}/include/tcl.h"
  ];

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
