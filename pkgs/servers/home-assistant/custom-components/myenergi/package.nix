{
  fetchFromGitHub,
  buildHomeAssistantComponent,
  lib,
  black,
  flake8,
  myenergi,
}:
buildHomeAssistantComponent rec {
  owner = "CJNE";
  domain = "myenergi";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "CJNE";
    repo = "ha-myenergi";
    tag = version;
    hash = "sha256-yjgTUA+XZbShGo2+MHmsqnl5XvmA/5YJdU2lLH51k58=";
  };

  propagatedBuildInputs = [
    myenergi
  ];

  meta = {
    description = "Home Assistant integration for MyEnergi devices";
    homepage = "https://github.com/CJNE/ha-myenergi/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benediktbroich ];
  };
}
