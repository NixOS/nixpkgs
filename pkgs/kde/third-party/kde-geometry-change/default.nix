{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kde-geometry-change";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "peterfajdiga";
    repo = "kwin4_effect_geometry_change";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H3cslx6ceAJGXSa0+gNzmUINRoLeYODhGt4pSFfgNbQ=";
  };

  nativeBuildInputs = [
    nodejs
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kwin/effects/kwin4_effect_geometry_change/
    cp -r package/* $out/share/kwin/effects/kwin4_effect_geometry_change/

    runHook postInstall
  '';

  LANG = "C.UTF-8";

  meta = {
    description = "A KWin animation for windows moved or resized by programs or scripts ";
    homepage = "https://github.com/peterfajdiga/kwin4_effect_geometry_change";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [eymeric];
    platforms = lib.platforms.all;
  };
})
