{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  aiofiles,
}:

buildHomeAssistantComponent rec {
  owner = "hultenvp";
  domain = "solis";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "hultenvp";
    repo = "solis-sensor";
    rev = "v${version}";
    sha256 = "sha256-DIUhUN1UfyXptaldJBsQEsImEnQqi4zFFKp70yXxDSk=";
  };

  dependencies = [ aiofiles ];

  meta = with lib; {
    description = "Home Assistant integration for the SolisCloud PV Monitoring portal via SolisCloud API";
    homepage = "https://github.com/hultenvp/solis-sensor";
    license = licenses.asl20;
    maintainers = with maintainers; [ jnsgruk ];
  };
}
