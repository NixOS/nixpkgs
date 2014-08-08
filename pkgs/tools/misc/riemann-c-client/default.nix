{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, file, protobufc }:

stdenv.mkDerivation rec {
  name = "riemann-c-client-${version}";

  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/algernon/riemann-c-client/archive/${name}.tar.gz";
    sha256 = "1w3rx0hva605d5vzlhhm4pb43ady0m3s4mz8ix1ycn4b8cq9jsjs";
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
