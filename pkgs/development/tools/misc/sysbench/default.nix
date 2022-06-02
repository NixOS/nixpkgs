{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, libmysqlclient, libaio
}:

stdenv.mkDerivation rec {
  pname = "sysbench";
  version = "1.0.20";

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libmysqlclient libaio ];

  src = fetchFromGitHub {
    owner = "akopytov";
    repo = pname;
    rev = version;
    sha256 = "1sanvl2a52ff4shj62nw395zzgdgywplqvwip74ky8q7s6qjf5qy";
  };

  enableParallelBuilding = true;

  meta = {
    description = "Modular, cross-platform and multi-threaded benchmark tool";
    homepage = "https://github.com/akopytov/sysbench";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
