{ lib, stdenv, fetchurl, tcl }:

stdenv.mkDerivation rec {
  pname = "eggdrop";
  version = "1.9.4";

  src = fetchurl {
    url = "https://ftp.eggheads.org/pub/eggdrop/source/${lib.versions.majorMinor version}/eggdrop-${version}.tar.gz";
    hash = "sha256-DCh+N+h7XBidScnl2I9cwzhsmMB0MdPmAzgDwYkCltE=";
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
