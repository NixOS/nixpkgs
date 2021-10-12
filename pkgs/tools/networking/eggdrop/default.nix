{ lib, stdenv, fetchFromGitHub, tcl }:

stdenv.mkDerivation rec {
  pname = "eggdrop";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "eggheads";
    repo = "eggdrop";
    rev = "v${version}";
    sha256 = "sha256-vh8nym7aYeTRUQ7FBZRy4ToG2ajwRDhzi4jNiJQOEyQ=";
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
    homepage = "http://www.eggheads.org";
    description = "An Internet Relay Chat (IRC) bot";
  };
}
