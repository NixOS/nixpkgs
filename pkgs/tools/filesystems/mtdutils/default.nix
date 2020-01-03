{ stdenv, fetchurl, autoreconfHook, pkgconfig, cmocka, acl, libuuid, lzo, zlib, zstd }:

stdenv.mkDerivation rec {
  pname = "mtd-utils";
  version = "2.1.1";

  src = fetchurl {
    url = "ftp://ftp.infradead.org/pub/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1lijl89l7hljx8xx70vrz9srd3h41v5gh4b0lvqnlv831yvyh5cd";
  };

  nativeBuildInputs = [ autoreconfHook cmocka pkgconfig ];
  buildInputs = [ acl libuuid lzo zlib zstd ];

  configureFlags = [ "--enable-unit-tests" "--enable-tests" ];
  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Tools for MTD filesystems";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = "http://www.linux-mtd.infradead.org/";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
