{ stdenv, fetchFromGitHub, tcl }:

stdenv.mkDerivation rec {
  pname = "eggdrop";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "eggheads";
    repo = "eggdrop";
    rev = "v${version}";
    sha256 = "0xqdrv4ydxw72a740lkmpg3fs7ldicaf08b0sfqdyaj7cq8l5x5l";
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

  meta = with stdenv.lib; {
    license = licenses.gpl2;
    platforms = platforms.unix;
    homepage = "http://www.eggheads.org";
    description = "An Internet Relay Chat (IRC) bot";
  };
}
