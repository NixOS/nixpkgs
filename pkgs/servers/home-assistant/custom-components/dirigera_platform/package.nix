{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  dirigera,
}:

buildHomeAssistantComponent rec {
  owner = "sanjoyg";
  domain = "dirigera_platform";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "sanjoyg";
    repo = "dirigera_platform";
    rev = version;
    hash = "sha256-P4yjZ+SQSLSHI3m3wBlH9YlGlktURoGA1jFFxJ7B020=";
  };

  propagatedBuildInputs = [
    dirigera
  ];

  meta = with lib; {
    description = "Home-assistant integration for IKEA Dirigera hub";
    homepage = "https://github.com/sanjoyg/dirigera_platform";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.mit;
  };
}
