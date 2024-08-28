{ lib, stdenv, fetchurl, pkg-config, udev, buildPackages }:

stdenv.mkDerivation rec {
  pname = "libatasmart";
  version = "0.19";

  src = fetchurl {
    url = "http://0pointer.de/public/libatasmart-${version}.tar.xz";
    sha256 = "138gvgdwk6h4ljrjsr09pxk1nrki4b155hqdzyr8mlk3bwsfmw31";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  meta = with lib; {
    homepage = "http://0pointer.de/blog/projects/being-smart.html";
    description = "Library for querying ATA SMART status";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
