{ stdenv, fetchurl, docutils, libev, openssl, pkgconfig }:
stdenv.mkDerivation rec {
  version = "1.4.8";
  name = "hitch-${version}";

  src = fetchurl {
    url = "https://hitch-tls.org/source/${name}.tar.gz";
    sha256 = "1hqs5p69gr1lb3xldbrgq7d6d0vk4za0wpizlzybn98cv68acaym";
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
