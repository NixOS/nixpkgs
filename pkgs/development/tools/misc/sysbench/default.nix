{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, vim, mysql
, libaio }:

stdenv.mkDerivation rec {
  name = "sysbench-1.0.15";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ vim mysql.connector-c libaio ];

  src = fetchFromGitHub {
    owner = "akopytov";
    repo = "sysbench";
    rev = "1.0.15";
    sha256 = "0ddj4mxxqlnlp817ix2qad0v3p83azi9wyz4h7mffchgp3mndp9z";
  };

  meta = {
    description = "Modular, cross-platform and multi-threaded benchmark tool";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
