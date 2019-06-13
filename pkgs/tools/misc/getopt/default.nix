{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "getopt";
  version = "1.1.6";
  src = fetchurl {
    url = "http://frodo.looijaard.name/system/files/software/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1zn5kp8ar853rin0ay2j3p17blxy16agpp8wi8wfg4x98b31vgyh";
  };

  makeFlags = [
    "WITHOUT_GETTEXT=1"
    "LIBCGETOPT=0"
    "prefix=${placeholder "out"}"
    "CC:=$(CC)"
  ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
