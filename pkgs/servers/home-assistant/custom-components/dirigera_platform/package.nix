{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  dirigera,
}:

buildHomeAssistantComponent rec {
  owner = "sanjoyg";
  domain = "dirigera_platform";
  version = "2.6.8";

  src = fetchFromGitHub {
    owner = "sanjoyg";
    repo = "dirigera_platform";
    rev = version;
    hash = "sha256-FNcGl6INQlVP+P3qmExWLI1ALh9ZacjJAbNKRtgM3ms=";
  };

  postPatch = ''
    substituteInPlace custom_components/dirigera_platform/manifest.json \
      --replace-fail "0.0.1" "${version}"
  '';

  dependencies = [ dirigera ];

  ignoreVersionRequirement = [ "dirigera" ];

  meta = with lib; {
    description = "Home-assistant integration for IKEA Dirigera hub";
    homepage = "https://github.com/sanjoyg/dirigera_platform";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.mit;
  };
}
