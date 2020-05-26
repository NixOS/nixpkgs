{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  pname = "ipset";
  version = "7.6";

  src = fetchurl {
    url = "http://ipset.netfilter.org/${pname}-${version}.tar.bz2";
    sha256 = "1ny2spcm6bmpj8vnazssg99k59impr7n84jzkdmdjly1m7548z8f";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmnl ];

  configureFlags = [ "--with-kmod=no" ];

  meta = with stdenv.lib; {
    homepage = "http://ipset.netfilter.org/";
    description = "Administration tool for IP sets";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
