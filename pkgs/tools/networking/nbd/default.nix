{ stdenv, fetchurl, pkgconfig, glib, which }:

stdenv.mkDerivation rec {
  name = "nbd-3.20";

  src = fetchurl {
    url = "mirror://sourceforge/nbd/${name}.tar.xz";
    sha256 = "1kfnyx52nna2mnw264njk1dl2zc8m78sz031yp65mbmpi99v7qg0";
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
