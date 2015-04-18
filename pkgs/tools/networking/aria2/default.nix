{ stdenv, fetchurl, pkgconfig, cacert, c-ares, openssl, libxml2, sqlite, zlib }:

stdenv.mkDerivation rec {
  name = "aria2-${version}";
  version = "1.18.10";

  src = fetchurl {
    url = "mirror://sourceforge/aria2/stable/${name}/${name}.tar.bz2";
    sha256 = "1vvc3pv1100xb4293bmgqpxvy3pdvivnz415b9q78n7190kag3a5";
  };

  buildInputs = [ pkgconfig c-ares openssl libxml2 sqlite zlib ];

  propagatedBuildInputs = [ cacert ];

  configureFlags = [ "--with-ca-bundle=${cacert}/etc/ca-bundle.crt" ];

  meta = with stdenv.lib; {
    homepage = http://aria2.sourceforge.net/;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
    maintainers = [ maintainers.koral ];
    license = licenses.gpl2Plus;
  };
}
