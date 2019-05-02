{ stdenv, fetchurl, pkgconfig, glib, which }:

stdenv.mkDerivation rec {
  name = "nbd-3.19";

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.xz";
    sha256 = "1446rdg490fxd8mg5gvrf4nddbw1w7lf2daxy9cpc19yy4968iml";
  };

  buildInputs = [ glib ]
    ++ stdenv.lib.optional (stdenv ? glibc) stdenv.glibc.linuxHeaders;

  nativeBuildInputs = [ pkgconfig which ];

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
