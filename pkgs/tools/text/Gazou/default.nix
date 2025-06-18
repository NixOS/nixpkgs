# gazou.nix
{ lib, stdenv, fetchFromGitHub, cmake, leptonica, pkgconfig, qtbase, qtx11extras, tesseract, wrapQtAppsHook }:

stdenv.mkDerivation {
  pname = "gazou";
  version = "unstable-2023-05-14";

  src = fetchFromGitHub {
    owner = "kamui-fin";
    repo = "gazou";
    rev = "2114963698c94ec7e8f9023f8b6dbfa8437337de";
    sha256 = "sha256-CiIQNwL+vrCLgmOdPt6OaS0dJfw46lhM9u4hUSlTW5I=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkgconfig wrapQtAppsHook ];
  buildInputs = [ tesseract leptonica qtbase qtx11extras ];

  cmakeArgs = [
    "-DGUI=ON"
  ];

  meta = {
    description = "A OCR for Japanese and Chinese Characters";
    license = lib.licenses.gpl3Only;
    homepage = "https://github.com/kamui-fin/gazou";
    maintainers = with lib.maintainers; [ jaminW55 ];
  };
}
