{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "sedutil";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner  = "Drive-Trust-Alliance";
    repo   = "sedutil";
    rev    = version;
    sha256 = "0zg5v27vbrzzl2vqzks91zj48z30qgcshkqkm1g8ycnhi145l0mf";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "DTA sedutil Self encrypting drive software";
    homepage    = "https://www.drivetrust.com";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
  };
}
