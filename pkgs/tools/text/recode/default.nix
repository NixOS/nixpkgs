{ stdenv, fetchFromGitHub, python, perl, intltool, flex, autoreconfHook
, texinfo, libiconv, libintl }:

stdenv.mkDerivation rec {
  pname = "recode";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "rrthomas";
    repo = pname;
    rev = "v${version}";
    sha256 = "06xdln5lc7ba7s7x911zbyncg8dp1ybn5pxzmkr95hf1bid23rdq";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ python perl intltool flex texinfo autoreconfHook libiconv ];
  buildInputs = [ libintl ];

  #doCheck = false; # fails 10 out of 16 tests

  #preCheck = ''
  #  checkFlagsArray=(CPPFLAGS="-I../lib" LDFLAGS="-L../src/.libs -Wl,-rpath=../src/.libs")
  #'';

  meta = {
    homepage = https://github.com/rrthomas/recode;
    description = "Converts files between various character sets and usages";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
