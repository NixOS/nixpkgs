{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, file, protobufc }:

stdenv.mkDerivation rec {
  name = "riemann-c-client-${version}";

  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/algernon/riemann-c-client/archive/${name}.tar.gz";
    sha256 = "10nz20svf1nb6kymwp0x49nvwnxakby33r6jsadish1fjcvzki88";
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
