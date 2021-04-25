{ lib, stdenv, fetchurl, cmake, python3
, bison, openssl, readline, bzip2
, perl
}:

let
  perlWithDBI = perl.withPackages (p: [ p.DBDMonetdb ]);

in stdenv.mkDerivation rec {
  pname = "monetdb";
  version = "11.39.15";

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${version}.tar.bz2";
    sha256 = "0g8xw6mxm9dhd0yjwln0f0rs59yhs8zr34hppv5g91n371ghn693";
  };

  postPatch = ''
    substituteInPlace cmake/monetdb-packages.cmake --replace \
      'get_os_release_info(LINUX_DISTRO LINUX_DISTRO_VERSION)' \
      'set(LINUX_DISTRO "nixos")'
  '';

  postFixup = ''
    substituteInPlace "$out/bin/malsample.pl" --replace \
      '#!/usr/bin/env perl' \
      '#!${perlWithDBI}/bin/perl'
    substituteInPlace "$out/bin/sqlsample.pl" --replace \
      '#!/usr/bin/env perl' \
      '#!${perlWithDBI}/bin/perl'
  '';

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ bison openssl readline bzip2 ];

  meta = with lib; {
    description = "An open source database system";
    homepage = "https://www.monetdb.org/";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.StillerHarpo ];
  };
}
