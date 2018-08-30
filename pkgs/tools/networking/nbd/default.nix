{ stdenv, fetchurl, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "nbd-3.18";

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.xz";
    sha256 = "0cb0sjiv0j9sh9dk24nrjm7sa0axbrcp2av5hc91g1ryzk764dyq";
  };

  buildInputs =
    [ pkgconfig glib ]
    ++ stdenv.lib.optional (stdenv ? glibc) stdenv.glibc.linuxHeaders;

  postInstall = ''
    mkdir -p "$out/share/doc/${name}"
    cp README.md "$out/share/doc/${name}/"
  '';

  doCheck = true;

  # Glib calls `clock_gettime', which is in librt. Linking that library
  # here ensures that a proper rpath is added to the executable so that
  # it can be loaded at run-time.
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lrt -lpthread";

  meta = {
    homepage = http://nbd.sourceforge.net;
    description = "Map arbitrary files as block devices over the network";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.peti ];
    platforms = stdenv.lib.platforms.linux;
  };
}
