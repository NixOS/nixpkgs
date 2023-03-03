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

  meta = {
    homepage = "https://nbd.sourceforge.io/";
    description = "Map arbitrary files as block devices over the network";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
