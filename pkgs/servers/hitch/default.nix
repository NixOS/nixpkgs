{ stdenv, fetchurl, docutils, libev, openssl, pkgconfig, nixosTests }:
stdenv.mkDerivation rec {
  version = "1.6.0";
  pname = "hitch";

  src = fetchurl {
    url = "https://hitch-tls.org/source/${pname}-${version}.tar.gz";
    sha256 = "01n70yf8hx42jb801jv5q1xhrpqxyjnqhd98hjf81lvxpd5fnisf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ docutils libev openssl ];

  outputs = [ "out" "doc" "man" ];

  passthru.tests.hitch = nixosTests.hitch;

  meta = with stdenv.lib; {
    description = "Hitch is a libev-based high performance SSL/TLS proxy by Varnish Software";
    homepage = "https://hitch-tls.org/";
    license = licenses.bsd2;
    maintainers = [ maintainers.jflanglois ];
    platforms = platforms.linux;
  };
}
