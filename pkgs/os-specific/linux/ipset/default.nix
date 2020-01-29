{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  pname = "ipset";
  version = "7.5";

  src = fetchurl {
    url = "http://ipset.netfilter.org/${pname}-${version}.tar.bz2";
    sha256 = "02vangpxdyyk9z84vc0ba1vbjvfnd6zlniisc029xzkgmdafwym5";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmnl ];

  configureFlags = [ "--with-kmod=no" ];

  meta = with stdenv.lib; {
    homepage = http://ipset.netfilter.org/;
    description = "Administration tool for IP sets";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
