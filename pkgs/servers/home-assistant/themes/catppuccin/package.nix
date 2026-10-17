{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "catppuccin";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "home-assistant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+m6lWer9a4AwmTgckhSHOKd0Oo6x9N0jjza4/F0ye3E=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dt $out/themes themes/catppuccin.yaml
    runHook postInstall
  '';

  passthru.isHomeAssistantTheme = true;

  meta = {
    description = "Soothing pastel theme for Home Assistant";
    homepage = "https://github.com/catppuccin/home-assistant";
    changelog = "https://github.com/catppuccin/home-assistant/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.CardboardTurkey ];
  };
})
