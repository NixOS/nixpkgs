{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "schizza";
  domain = "sws12500";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "schizza";
    repo = "sws-12500-custom-component";
    tag = "v${version}";
    hash = "sha256-AH2ljZcsCXBZmmJc+97U03X2jqJlWQQTl9fmcGBtyrA=";
  };

  meta = {
    changelog = "https://github.com/schizza/sws-12500-custom-component/releases/tag/${src.tag}";
    description = "Integrates your Sencor SWS 12500 or 16600, GARNI, BRESSER weather stations seamlessly into Home Assistant";
    homepage = "https://github.com/schizza/sws-12500-custom-component";
    maintainers = with lib.maintainers; [ larsianer ];
    license = lib.licenses.mit;
  };
}
