{ stdenv, fetchurl, pkgconfig, autoreconfHook
, openssl, c-ares, libxml2, sqlite, zlib, libssh2
}:

stdenv.mkDerivation rec {
  name = "aria2-${version}";
  version = "1.19.0";

  src = fetchurl {
    url = "mirror://sourceforge/aria2/${name}.tar.xz";
    sha256 = "0xm4fmap9gp2pz6z01mnnpmazw6pnhzs8qc58181m5ai4gy5ksp2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl c-ares libxml2 sqlite zlib libssh2 ];

  configureFlags = [ "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tatsuhiro-t/aria2;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
    maintainers = with maintainers; [ koral jgeerds ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
