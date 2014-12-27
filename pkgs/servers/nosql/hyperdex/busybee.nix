{ stdenv, fetchurl, unzip, autoconf, automake, libtool,
  libpo6, libe, pkgconfig }:

stdenv.mkDerivation rec {
  name = "busybee-${version}";
  version = "0.5.2";

  src = fetchurl {
    url = "https://github.com/rescrv/busybee/archive/releases/${version}.zip";
    sha256 = "0gr5h2j9rzwarblgcgddnxj39i282rvgn9vqlrcd60dx8c4dkm29";
  };
  buildInputs = [
    autoconf
    automake
    libe
    libpo6
    libtool
    pkgconfig
    unzip
  ];
  preConfigure = "autoreconf -i";

  meta = with stdenv.lib; {
    description = "BusyBee is a high-performance messaging layer.";
    homepage = https://github.com/rescrv/busybee;
    license = licenses.bsd3;
  };
}
