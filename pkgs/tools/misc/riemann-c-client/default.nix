{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, file, protobufc }:

stdenv.mkDerivation rec {
  name = "riemann-c-client-${version}";

  version = "1.2.1";

  src = fetchurl {
    url = "https://github.com/algernon/riemann-c-client/archive/${name}.tar.gz";
    sha256 = "132yd1m523inmv17sd48xf7xdqb7jj36v7is1xw7w9nny6qxkzwm";
  };

  buildInputs = [ autoconf automake libtool pkgconfig file protobufc ];

  preConfigure = "autoreconf -i";

  meta = with stdenv.lib; {
    homepage = "https://github.com/algernon/riemann-c-client";
    description = "A C client library for the Riemann monitoring system";
    license = licenses.gpl3;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.linux;
  };
}
