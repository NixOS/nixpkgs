{ stdenv, fetchurl, unzip, autoreconfHook, glog,
  hyperleveldb, libe, pkgconfig, popt, libpo6, busybee }:

stdenv.mkDerivation rec {
  name = "replicant-${version}";
  version = "0.6.3";

  src = fetchurl {
    url = "https://github.com/rescrv/Replicant/archive/releases/${version}.zip";
    sha256 = "1q3pdq2ndpj70yd1578bn4grlrp77gl8hv2fz34jpx34qmlalda4";
  };

  buildInputs = [
    autoreconfHook
    busybee
    glog
    hyperleveldb
    libe
    libpo6
    pkgconfig
    popt
    unzip
  ];

  meta = with stdenv.lib; {
    description = "A system for maintaining replicated state machines";
    homepage = https://github.com/rescrv/Replicant;
    license = licenses.bsd3;
  };
}
