{ lib
, stdenv
, fetchFromGitHub
, cmake
, nix-update-script
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "upx";
  version = "4.2.3";
  src = fetchFromGitHub {
    owner = "upx";
    repo = "upx";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-3+aOadTqQ1apnrXt2I27j8P6iJF96W90YjxVTPmRhs0=";
  };

  nativeBuildInputs = [ cmake ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = with lib; {
    homepage = "https://upx.github.io/";
    description = "The Ultimate Packer for eXecutables";
    changelog = "https://github.com/upx/upx/blob/${finalAttrs.src.rev}/NEWS";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "upx";
  };
})
