{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, vim, libmysqlclient
, libaio }:

stdenv.mkDerivation {
  name = "sysbench-1.0.17";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ vim libmysqlclient libaio ];

  src = fetchFromGitHub {
    owner = "akopytov";
    repo = "sysbench";
    rev = "1.0.17";
    sha256 = "02i9knvp0bjw6ri848xxiy2dbww2xv70nah9yn67a6zgw617hwa6";
  };

  meta = {
    description = "Modular, cross-platform and multi-threaded benchmark tool";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
