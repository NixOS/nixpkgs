{
  lib,
  mkCataclysm,
  fetchFromGitHub,
}:
mkCataclysm (finalAttrs: {
  pname = "cataclysm-the-last-generation";
  version = "1.0-2025-11-06-0503";

  src = fetchFromGitHub {
    owner = "Cataclysm-TLG";
    repo = "Cataclysm-TLG";
    tag = "cataclysm-tlg-${finalAttrs.version}";
    hash = "sha256-8gwa3gx+PlJ7Yvdkv9j+qrn/KiXooiGM6KW2Xgr1xHs=";
  };

  postPatch = ''
    substituteInPlace data/CMakeLists.txt \
      --replace-fail "screenshots" ""
  '';

  useCmake = true;
  cmakeFlags = [
    (lib.cmakeFeature "GIT_VERSION" finalAttrs.version)
  ];

  meta = {
    homepage = "https://github.com/Cataclysm-TLG/Cataclysm-TLG/";
    changelog = "https://github.com/Cataclysm-TLG/Cataclysm-TLG/releases/tag/cataclysm-tlg-${finalAttrs.version}";
    description = "single-player turn-based postapocalyptic survival game based on the all-time classic Cataclysm: Dark Days Ahead";
  };
})
