{ stdenv, lib, fetchFromGitHub, cmake, ... }:
stdenv.mkDerivation rec {
  pname = "luametatex";
  version = "2.10.07";

  src = fetchFromGitHub {
    owner = "contextgarden";
    repo = "luametatex";
    rev = "v${version}";
    hash = "sha256-Ysq/6ms42rczyHAlSO8qwfMxCNT1fvO+x8nmkmSZR54=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "minimal tex engine based on luatex";
    homepage = "https://www.pragma-ade.nl/luametatex-1.htm";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
}
