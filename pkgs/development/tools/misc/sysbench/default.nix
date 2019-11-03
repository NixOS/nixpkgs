{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, vim, libmysqlclient
, libaio }:

stdenv.mkDerivation {
  name = "sysbench-1.0.18";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ vim libmysqlclient libaio ];

  src = fetchFromGitHub {
    owner = "akopytov";
    repo = "sysbench";
    rev = "1.0.18";
    sha256 = "1r6lkyfp65xqklj1rdfw551srqqyak144agi8x3wjz3wmsbqls19";
  };

  meta = {
    description = "Modular, cross-platform and multi-threaded benchmark tool";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
