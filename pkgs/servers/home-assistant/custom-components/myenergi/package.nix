{
  fetchFromGitHub,
  buildHomeAssistantComponent,
  lib,
  black,
  flake8,
  myenergi,
}:
buildHomeAssistantComponent {
  owner = "CJNE";
  domain = "myenergi";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "CJNE";
    repo = "ha-myenergi";
    rev = "71d4ddff0a9328924107a35442f3b587a5adceed";
    hash = "sha256-yjgTUA+XZbShGo2+MHmsqnl5XvmA/5YJdU2lLH51k58=";
  };

  propagatedBuildInputs = [
    black
    flake8
    myenergi
  ];

  meta = {
    description = "Home Assistant integration for MyEnergi devices";
    homepage = "https://github.com/CJNE/ha-myenergi/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benediktbroich ];
  };
}
