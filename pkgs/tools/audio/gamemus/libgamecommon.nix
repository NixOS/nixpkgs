{ stdenv, fetchFromGitHub, autoreconfHook, boost }:

stdenv.mkDerivation rec {
  name = "libgamecommon-${version}";
  version = "2017-12-02";

  src = fetchFromGitHub {
    owner = "Malvineous";
    repo = "libgamecommon";
    rev = "e6c4ff86b6fb8ef73d8fa8898541447a610e10c7";
    sha256 = "0b3v1c484sj8bczrqcgmxprd2nypz5d4f7775439dcpjkx8l8rsp";
  };

  doCheck = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ boost ];

  configureFlags = [
    "--with-boost-libdir=${boost}/lib"
    "--disable-shared"
  ];
}
