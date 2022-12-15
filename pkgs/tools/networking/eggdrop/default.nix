{ lib, stdenv, fetchFromGitHub, tcl }:

stdenv.mkDerivation rec {
  pname = "eggdrop";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "eggheads";
    repo = "eggdrop";
    rev = "v${version}";
    sha256 = "sha256-QmArhPp4m9XTTAkbqNIffZT//gt3pk8NJef7C2BdxxA=";
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
    "--with-tcllib=${tcl}/lib/lib${tcl.libPrefix}${stdenv.hostPlatform.extensions.sharedLibrary}"
    "--with-tclinc=${tcl}/include/tcl.h"
  ];

  meta = with lib; {
    license = licenses.gpl2;
    platforms = platforms.unix;
    homepage = "https://www.eggheads.org";
    description = "An Internet Relay Chat (IRC) bot";
  };
}
