{ lib
, stdenv
, fetchFromGitHub
, cmake
, nix-update-script
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "upx";
  version = "4.2.2";
  src = fetchFromGitHub {
    owner = "upx";
    repo = "upx";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-0x7SUW+rB5HNRoRkCQIwfOIMpu+kOifxA7Z3SUlY/ME=";
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
