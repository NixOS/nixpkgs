{ stdenv, fetchurl, unzip, autoconf, automake, libtool, glog,
  hyperleveldb, libe, pkgconfig, popt, libpo6, busybee }:

stdenv.mkDerivation rec {
  name = "replicant-${version}";
  version = "0.6.3";

  src = fetchurl {
    url = "https://github.com/rescrv/Replicant/archive/releases/${version}.zip";
    sha256 = "1q3pdq2ndpj70yd1578bn4grlrp77gl8hv2fz34jpx34qmlalda4";
  };
  buildInputs = [
    autoconf
    automake
    busybee
    glog
    hyperleveldb
    libe
    libpo6
    libtool
    pkgconfig
    popt
    unzip
  ];
  preConfigure = "autoreconf -i";
  
  meta = with stdenv.lib; {
    description = "A system for maintaining replicated state machines";
    homepage = https://github.com/rescrv/Replicant;
    license = licenses.bsd3;
  };
}
