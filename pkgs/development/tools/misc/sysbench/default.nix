{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, vim, mysql
, libaio }:

stdenv.mkDerivation rec {
  name = "sysbench-1.0.16";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ vim mysql.connector-c libaio ];

  src = fetchFromGitHub {
    owner = "akopytov";
    repo = "sysbench";
    rev = "1.0.16";
    sha256 = "0ypain0m1yqn7yqfb5847fdph6a6m0rn2rnqbnkxcxz5g85kv1rg";
  };

  meta = {
    description = "Modular, cross-platform and multi-threaded benchmark tool";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
