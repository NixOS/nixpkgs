{ stdenv, fetchurl, python3, perl, intltool, flex, texinfo, libiconv, libintl }:

stdenv.mkDerivation rec {
  pname = "recode";
  version = "3.7.6";

  # Use official tarball, avoid need to bootstrap/generate build system
  src = fetchurl {
    url = "https://github.com/rrthomas/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "0m59sd1ca0zw1aydpc3m8sw03nc885knmccqryg7byzmqs585ia6";
  };

  nativeBuildInputs = [ python3 python3.pkgs.cython perl intltool flex texinfo libiconv ];
  buildInputs = [ libintl ];

  doCheck = true;

  meta = {
    homepage = https://github.com/rrthomas/recode;
    description = "Converts files between various character sets and usages";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
