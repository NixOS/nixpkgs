{ lib, stdenv, fetchurl, python3, perl, intltool, flex, texinfo, libiconv, libintl }:

stdenv.mkDerivation rec {
  pname = "recode";
  version = "3.7.8";

  # Use official tarball, avoid need to bootstrap/generate build system
  src = fetchurl {
    url = "https://github.com/rrthomas/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "19yg20z1smj9kag1axgvc4s4kd6jmw75h0pa8xqxl3xqqyn5rdsg";
  };

  nativeBuildInputs = [ python3 python3.pkgs.cython perl intltool flex texinfo libiconv ];
  buildInputs = [ libintl ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/rrthomas/recode";
    description = "Converts files between various character sets and usages";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
