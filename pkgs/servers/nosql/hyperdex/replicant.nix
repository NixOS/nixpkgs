{ stdenv, fetchurl, unzip, autoconf, automake, libtool, glog,
  hyperleveldb, libe, pkgconfig, popt, libpo6, busybee }:

stdenv.mkDerivation rec {
  name = "replicant-${version}";
  version = "0.5.2";

  src = fetchurl {
    url = "https://github.com/rescrv/Replicant/archive/releases/0.6.3.zip";
    sha256 = "1fbagz0nbvinkqr5iw5y187dm4klkswrxnl5ysq8waglg2nj8zzi";
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
    description = "A system for maintaining replicated state machines.";
    homepage = https://github.com/rescrv/Replicant;
    license = licenses.bsd3;
  };
}
