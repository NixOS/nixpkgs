{ stdenv, fetchurl, python3, perl, intltool, flex, texinfo, libiconv, libintl }:

stdenv.mkDerivation rec {
  pname = "recode";
  version = "3.7.7";

  # Use official tarball, avoid need to bootstrap/generate build system
  src = fetchurl {
    url = "https://github.com/rrthomas/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "1yrqgw74qrdmy82lxd1cxlfclrf2fqi0qp7afjmfc6b7f0xzcih9";
  };

  nativeBuildInputs = [ python3 python3.pkgs.cython perl intltool flex texinfo libiconv ];
  buildInputs = [ libintl ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/rrthomas/recode";
    description = "Converts files between various character sets and usages";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
