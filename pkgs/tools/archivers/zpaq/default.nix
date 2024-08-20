{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  pname = "zpaq";
  version = "7.15";

  src = fetchFromGitHub {
    owner = "zpaq";
    repo = "zpaq";
    rev = version;
    sha256 = "0v44rlg9gvwc4ggr2lhcqll8ppal3dk7zsg5bqwcc5lg3ynk2pz4";
  };

  nativeBuildInputs = [ perl /* for pod2man */ ];

  CPPFLAGS = [ "-Dunix" ] ++
    lib.optional (!stdenv.isi686 && !stdenv.isx86_64) "-DNOJIT";
  CXXFLAGS = [ "-O3" "-DNDEBUG" ];

  enableParallelBuilding = true;

  makeFlags = [ "CXX=${stdenv.cc.targetPrefix}c++" ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Incremental journaling backup utility and archiver";
    homepage = "http://mattmahoney.net/dc/zpaq.html";
    license = licenses.gpl3Plus ;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    mainProgram = "zpaq";
  };
}
