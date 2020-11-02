{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  pname = "ipset";
  version = "7.7";

  src = fetchurl {
    url = "http://ipset.netfilter.org/${pname}-${version}.tar.bz2";
    sha256 = "0ckc678l1431mb0q5ilfgy0ajjwi8n135c72h606imm43dc0v9a5";
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
