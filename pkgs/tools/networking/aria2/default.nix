{ stdenv, fetchurl, pkgconfig, c-ares, openssl, libxml2, sqlite, zlib }:

stdenv.mkDerivation rec {
  name = "aria2-${version}";
  version = "1.19.0";

  src = fetchurl {
    url = "mirror://sourceforge/aria2/stable/${name}/${name}.tar.xz";
    sha256 = "0xm4fmap9gp2pz6z01mnnpmazw6pnhzs8qc58181m5ai4gy5ksp2";
  };

  buildInputs = [ pkgconfig c-ares openssl libxml2 sqlite zlib ];

  configureFlags = [ "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt" ];

  meta = with stdenv.lib; {
    homepage = http://aria2.sourceforge.net/;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
    maintainers = [ maintainers.koral ];
    license = licenses.gpl2Plus;
  };
}
