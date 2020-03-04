{ stdenv, fetchurl, docutils, libev, openssl, pkgconfig }:
stdenv.mkDerivation rec {
  version = "1.5.2";
  pname = "hitch";

  src = fetchurl {
    url = "https://hitch-tls.org/source/${pname}-${version}.tar.gz";
    sha256 = "1nnzqqigfw78nqhp81a72x1s8d6v49ayw4w5df0zzm2cb1jgv95i";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ docutils libev openssl ];

  outputs = [ "out" "doc" "man" ];

  meta = with stdenv.lib; {
    description = "Hitch is a libev-based high performance SSL/TLS proxy by Varnish Software";
    homepage = https://hitch-tls.org/;
    license = licenses.bsd2;
    maintainers = [ maintainers.jflanglois ];
    platforms = platforms.linux;
  };
}
