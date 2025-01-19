{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  dirigera,
}:

buildHomeAssistantComponent rec {
  owner = "sanjoyg";
  domain = "dirigera_platform";
  version = "2.6.6";

  src = fetchFromGitHub {
    owner = "sanjoyg";
    repo = "dirigera_platform";
    rev = version;
    hash = "sha256-OoTmEVjo6pzFQ5uoZOcmpOhVUoM2DM8HBAvJA58zjAU=";
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
