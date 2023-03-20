{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "sedutil";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "Drive-Trust-Alliance";
    repo = "sedutil";
    rev = version;
    sha256 = "sha256-NG/7aqe48ShHWW5hW8axYWV4+zX0dBE7Wy9q58l0S3E=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "DTA sedutil Self encrypting drive software";
    homepage = "https://www.drivetrust.com";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
