{ lib, stdenv, fetchurl, python3, perl, intltool, flex, texinfo, libiconv, libintl }:

stdenv.mkDerivation rec {
  pname = "recode";
  version = "3.7.12";

  # Use official tarball, avoid need to bootstrap/generate build system
  src = fetchurl {
    url = "https://github.com/rrthomas/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-TbHJB28E26oVlyb1AAhH5eWoOuyOXGT4ygQ4P2zaEtU=";
  };

  nativeBuildInputs = [ python3 python3.pkgs.cython perl intltool flex texinfo libiconv ];
  buildInputs = [ libintl ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    homepage = "https://github.com/rrthomas/recode";
    description = "Converts files between various character sets and usages";
    changelog = "https://github.com/rrthomas/recode/raw/v${version}/NEWS";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [ lgpl3Plus gpl3Plus ];
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
