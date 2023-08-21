{ stdenv, lib, fetchFromGitHub, cmake, ... }:
stdenv.mkDerivation (finalAttrs: {
  pname = "luametatex";
  version = "2.10.08";

  src = fetchFromGitHub {
    owner = "contextgarden";
    repo = "luametatex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KLRsJVzGyfbOfFSxUyT8mdxZ1Ud4EZrSxVB72i5jREU=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "minimal tex engine based on luatex";
    homepage = "https://www.pragma-ade.nl/luametatex-1.htm";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
})
