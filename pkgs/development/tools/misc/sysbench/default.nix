{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libmysqlclient, libaio
}:

stdenv.mkDerivation rec {
  pname = "sysbench";
  version = "1.0.18";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libmysqlclient libaio ];

  src = fetchFromGitHub {
    owner = "akopytov";
    repo = pname;
    rev = version;
    sha256 = "1r6lkyfp65xqklj1rdfw551srqqyak144agi8x3wjz3wmsbqls19";
  };

  enableParallelBuilding = true;

  meta = {
    description = "Modular, cross-platform and multi-threaded benchmark tool";
    homepage = https://github.com/akopytov/sysbench;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
