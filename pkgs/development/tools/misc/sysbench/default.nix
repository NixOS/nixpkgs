{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, vim, libmysql,
  libaio }:

stdenv.mkDerivation rec {
  name = "sysbench-1.0.6";

  buildInputs = [ autoreconfHook pkgconfig vim libmysql libaio ];

  src = fetchFromGitHub {
    owner = "akopytov";
    repo = "sysbench";
    rev = "1.0.6";
    sha256 = "0y3hlhzrggyyxwf378n006zlg2kwhmhh6vq6il0qn9agjmjmhl5l";
  };

  meta = {
    description = "Modular, cross-platform and multi-threaded benchmark tool";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
