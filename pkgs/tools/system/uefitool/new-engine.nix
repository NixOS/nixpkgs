{ lib, stdenv, fetchFromGitHub, qtbase, cmake, wrapQtAppsHook, zip }:

stdenv.mkDerivation rec {
  pname = "uefitool";
  version = "A68";

  src = fetchFromGitHub {
    sha256 = "fGeqY0mzMFflEJv/d6J8DpGS7YXiX5FRYG6yTdy+ksY=";
    owner = "LongSoft";
    repo = pname;
    rev = version;
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ cmake zip wrapQtAppsHook ];
  patches = lib.optionals stdenv.isDarwin [ ./bundle-destination.patch ];

  meta = with lib; {
    description = "UEFI firmware image viewer and editor";
    homepage = "https://github.com/LongSoft/uefitool";
    license = licenses.bsd2;
    maintainers = with maintainers; [ athre0z ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
