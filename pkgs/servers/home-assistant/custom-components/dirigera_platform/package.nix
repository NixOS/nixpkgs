{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  dirigera,
}:

buildHomeAssistantComponent rec {
  owner = "sanjoyg";
  domain = "dirigera_platform";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "sanjoyg";
    repo = "dirigera_platform";
    tag = version;
    hash = "sha256-N4H07CmIEqUqv1VkLlL1f924TvZ4Cb4IuVKlRYJA9CM=";
  };

  postPatch = ''
    substituteInPlace custom_components/dirigera_platform/manifest.json \
      --replace-fail "0.0.1" "${version}"
  '';

  dependencies = [ dirigera ];

  ignoreVersionRequirement = [ "dirigera" ];

  meta = {
    description = "Home-assistant integration for IKEA Dirigera hub";
    homepage = "https://github.com/sanjoyg/dirigera_platform";
    maintainers = with lib.maintainers; [ rhoriguchi ];
    license = lib.licenses.mit;
  };
}
