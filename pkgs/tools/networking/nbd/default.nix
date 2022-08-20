{ lib, stdenv, fetchurl, pkg-config, glib, which, bison, nixosTests, linuxHeaders, gnutls }:

stdenv.mkDerivation rec {
  pname = "nbd";
  version = "3.24";

  src = fetchurl {
    url = "mirror://sourceforge/nbd/nbd-${version}.tar.xz";
    sha256 = "sha256-aHcVbSOnsz917uidL1wskcVCr8PNy2Nt6lqIU5pY0Qw=";
  };

  buildInputs = [ glib gnutls ]
    ++ lib.optionals stdenv.isLinux [ linuxHeaders ];

  nativeBuildInputs = [ pkg-config which bison ];

  postInstall = ''
    mkdir -p "$out/share/doc/nbd-${version}"
    cp README.md "$out/share/doc/nbd-${version}/"
  '';

  doCheck = !stdenv.isDarwin;

  passthru.tests = {
    test = nixosTests.nbd;
  };

  # Glib calls `clock_gettime', which is in librt. Linking that library
  # here ensures that a proper rpath is added to the executable so that
  # it can be loaded at run-time.
  NIX_LDFLAGS = lib.optionalString stdenv.isLinux "-lrt -lpthread";

  meta = {
    homepage = "https://nbd.sourceforge.io/";
    description = "Map arbitrary files as block devices over the network";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
