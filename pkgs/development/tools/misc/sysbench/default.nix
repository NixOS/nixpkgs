{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, vim, mysql
, libaio }:

stdenv.mkDerivation rec {
  name = "sysbench-1.0.14";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ vim mysql.connector-c libaio ];

  src = fetchFromGitHub {
    owner = "akopytov";
    repo = "sysbench";
    rev = "1.0.14";
    sha256 = "0mp1wqdm87zqyn55z23qf1izqz7ijgcbsysdwqndd98w6m5d86rp";
  };

  meta = {
    description = "Modular, cross-platform and multi-threaded benchmark tool";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
