{ lib, stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation rec {
  pname = "cproto";
  version = "4.7r";

  src = fetchurl {
    urls = [
      "mirror://debian/pool/main/c/cproto/cproto_${version}.orig.tar.gz"
      # No version listings and apparently no versioned tarball over http(s).
      "ftp://ftp.invisible-island.net/cproto/cproto-${version}.tgz"
    ];
    sha256 = "sha256-bgRg2yVZXHobUz8AUaV4ZKBkp2KjP+2oXbDXmPTUX8U=";
  };

  # patch made by Joe Khoobyar copied from gentoo bugs
  patches = [ ./cproto.patch ];

  nativeBuildInputs = [ flex bison ];

  doCheck = true;

  doInstallCheck = true;
  installCheckPhase = ''
    [ "$("$out/bin/cproto" -V 2>&1)" = '${version}' ]
  '';

  meta = with lib; {
    description = "Tool to generate C function prototypes from C source code";
    homepage = "https://invisible-island.net/cproto/";
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
