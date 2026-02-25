{
  lib,
  buildHomeAssistantTheme,
  fetchFromGitHub,
}:

buildHomeAssistantTheme rec {
  pname = "material-you-theme";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-theme";
    tag = version;
    hash = "sha256-xJXhvKwp/l08/ZWi3OcGPmCdsUiMjBDwrKz5OIpD2t8=";
  };

  meta = {
    description = "Material Design 3 Theme for Home Assistant";
    homepage = "https://github.com/Nerwyn/material-you-theme";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpinz ];
  };
}
