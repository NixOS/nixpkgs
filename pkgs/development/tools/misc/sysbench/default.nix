{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libmysqlclient, libaio
}:

stdenv.mkDerivation rec {
  pname = "sysbench";
  version = "1.0.19";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libmysqlclient libaio ];

  src = fetchFromGitHub {
    owner = "akopytov";
    repo = pname;
    rev = version;
    sha256 = "1zgqb9cr7ld3vw4a3jhq1mlszhcyjlpr0c8q1jcp1d27l9dcvd1w";
  };

  enableParallelBuilding = true;

  meta = {
    description = "Modular, cross-platform and multi-threaded benchmark tool";
    homepage = https://github.com/akopytov/sysbench;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
