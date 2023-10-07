{ lib
, stdenv
, fetchFromGitHub
, cmake
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "fatcat";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Gregwar";
    repo = "fatcat";
    rev = "v${version}";
    hash = "sha256-/iGNVP7Bz/UZAR+dFxAKMKM9jm07h0x0F3VGpdxlHdk=";
  };

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "FAT filesystems explore, extract, repair, and forensic tool";
    homepage = "https://github.com/Gregwar/fatcat";
    license = licenses.mit;
    maintainers = with maintainers; [ cynerd ];
  };
}
