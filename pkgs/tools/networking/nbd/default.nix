{ lib
, stdenv
, fetchurl
, pkg-config
, glib
, which
, bison
, nixosTests
, libnl
, linuxHeaders
, gnutls
}:

stdenv.mkDerivation rec {
  pname = "nbd";
  version = "3.25";

  src = fetchurl {
    url = "https://github.com/NetworkBlockDevice/nbd/releases/download/nbd-${version}/nbd-${version}.tar.xz";
    hash = "sha256-9cj9D8tXsckmWU0OV/NWQy7ghni+8dQNCI8IMPDL3Qo=";
  };

  nativeBuildInputs = [
    pkg-config
    which
    bison
  ];

  buildInputs = [
    glib
    gnutls
  ] ++ lib.optionals stdenv.isLinux [
    libnl
    linuxHeaders
  ];

  configureFlags = [
    "--sysconfdir=/etc"
  ];

  doCheck = !stdenv.isDarwin;

  passthru.tests = {
    test = nixosTests.nbd;
  };

  meta = {
    homepage = "https://nbd.sourceforge.io/";
    description = "Map arbitrary files as block devices over the network";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
