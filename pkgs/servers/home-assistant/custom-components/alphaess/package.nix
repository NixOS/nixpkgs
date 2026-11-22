{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  alphaessopenapi,
}:
buildHomeAssistantComponent rec {
  owner = "CharlesGillanders";
  domain = "alphaess";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "CharlesGillanders";
    repo = "homeassistant-alphaESS";
    tag = "v${version}";
    hash = "sha256-fwf0Iiebq/CVK8XMDSKlbQDsxv7rCBjhgrSa3Ibf24M=";
  };

  dependencies = [
    alphaessopenapi
  ];

  meta = {
    description = "Monitor your energy generation, storage, and usage data using the official API from Alpha ESS";
    homepage = "https://github.com/CharlesGillanders/homeassistant-alphaESS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benediktbroich ];
  };
}
