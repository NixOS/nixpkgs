{ lib
, stdenv
, fetchFromGitHub
, cmake
, nix-update-script
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "upx";
  version = "4.2.1";
  src = fetchFromGitHub {
    owner = "upx";
    repo = "upx";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    sha256 = "sha256-s4cZAb0rhCJrHI//IXLNYLhOzX1NRmN/t5IFgurwI30=";
  };

  nativeBuildInputs = [ cmake ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = with lib; {
    homepage = "https://upx.github.io/";
    description = "The Ultimate Packer for eXecutables";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "upx";
  };
})
