{ lib, stdenv, fetchurl, autoreconfHook, pkgconfig, cmocka, acl, libuuid, lzo, zlib, zstd }:

stdenv.mkDerivation rec {
  pname = "mtd-utils";
  version = "2.1.1";

  src = fetchurl {
    url = "ftp://ftp.infradead.org/pub/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1lijl89l7hljx8xx70vrz9srd3h41v5gh4b0lvqnlv831yvyh5cd";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ] ++ lib.optional doCheck cmocka;
  buildInputs = [ acl libuuid lzo zlib zstd ];

  configureFlags = [
    (lib.enableFeature doCheck "unit-tests")
    (lib.enableFeature doCheck "tests")
  ];
  enableParallelBuilding = true;

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  meta = {
    description = "Tools for MTD filesystems";
    license = lib.licenses.gpl2Plus;
    homepage = "http://www.linux-mtd.infradead.org/";
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux;
  };
}
