{ stdenv, fetchurl, docutils, libev, openssl, pkgconfig }:
stdenv.mkDerivation rec {
  version = "1.5.0";
  name = "hitch-${version}";

  src = fetchurl {
    url = "https://hitch-tls.org/source/${name}.tar.gz";
    sha256 = "02sd2p3jsbnqmldsjwzk5qcjc45k9n1x4ygjkx0kxxwjj9lm9hhf";
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
