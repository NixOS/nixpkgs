{ lib, stdenv, fetchurl, pkg-config, glib, which, bison, nixosTests, linuxHeaders, gnutls }:

stdenv.mkDerivation rec {
  pname = "nbd";
  version = "3.25";

  src = fetchurl {
    url = "https://github.com/NetworkBlockDevice/nbd/releases/download/nbd-${version}/nbd-${version}.tar.xz";
    hash = "sha256-9cj9D8tXsckmWU0OV/NWQy7ghni+8dQNCI8IMPDL3Qo=";
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
