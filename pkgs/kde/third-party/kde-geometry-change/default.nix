{
  lib,
  stdenv,
  fetchFromGitHub,
  kpackage,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kde-geometry-change";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "peterfajdiga";
    repo = "kwin4_effect_geometry_change";
    rev = "v${finalAttrs.version}";
    hash = "sha256-p4FpqagR8Dxi+r9A8W5rGM5ybaBXP0gRKAuzigZ1lyA=";
  };

  nativeBuildInputs = [
    kpackage
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    kpackagetool6  -i ./package --packageroot=$out/share/kwin/scripts || kpackagetool6 -u ./package --packageroot=$out/share/kwin/scripts

    runHook postInstall
  '';

  meta = {
    description = "A KWin animation for windows moved or resized by programs or scripts ";
    homepage = "https://github.com/peterfajdiga/kwin4_effect_geometry_change";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = lib.platforms.all;
  };
})
