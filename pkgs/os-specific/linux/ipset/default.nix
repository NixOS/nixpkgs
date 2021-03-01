{ lib, stdenv, fetchurl, pkg-config, libmnl }:

stdenv.mkDerivation rec {
  pname = "ipset";
  version = "7.10";

  src = fetchurl {
    url = "http://ipset.netfilter.org/${pname}-${version}.tar.bz2";
    sha256 = "sha256-skkGukPi/jIr1BhjR2dh10mkvd9c5MImW6BLA7x+nPY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  configureFlags = [ "--with-kmod=no" ];

  meta = with lib; {
    homepage = "http://ipset.netfilter.org/";
    description = "Administration tool for IP sets";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
