{ lib, stdenv, fetchurl, pkg-config, glib, which, nixosTests }:

stdenv.mkDerivation rec {
  pname = "nbd";
  version = "3.21";

  src = fetchurl {
    url = "mirror://sourceforge/nbd/nbd-${version}.tar.xz";
    sha256 = "sha256-52iK852Rczu80tsIBixE/lA9AE5RUodAE5xEr/amvvk=";
  };

  buildInputs = [ glib ]
    ++ lib.optional (stdenv ? glibc) stdenv.glibc.linuxHeaders;

  nativeBuildInputs = [ pkg-config which ];

  postInstall = ''
    mkdir -p "$out/share/doc/nbd-${version}"
    cp README.md "$out/share/doc/nbd-${version}/"
  '';

  doCheck = true;

  passthru.tests = {
    test = nixosTests.nbd;
  };

  # Glib calls `clock_gettime', which is in librt. Linking that library
  # here ensures that a proper rpath is added to the executable so that
  # it can be loaded at run-time.
  NIX_LDFLAGS = lib.optionalString stdenv.isLinux "-lrt -lpthread";

  meta = {
    homepage = "http://nbd.sourceforge.net";
    description = "Map arbitrary files as block devices over the network";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
