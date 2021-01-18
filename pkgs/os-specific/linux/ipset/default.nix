{ lib, stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  pname = "ipset";
  version = "7.9";

  src = fetchurl {
    url = "http://ipset.netfilter.org/${pname}-${version}.tar.bz2";
    sha256 = "02mkp7vmsh609dcp02xi290sxmsgq2fsch3875dxkwfxkrl16p5p";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmnl ];

  configureFlags = [ "--with-kmod=no" ];

  meta = with lib; {
    homepage = "http://ipset.netfilter.org/";
    description = "Administration tool for IP sets";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
