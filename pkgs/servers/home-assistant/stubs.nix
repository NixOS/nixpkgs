{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, home-assistant
}:

buildPythonPackage rec {
  pname = "homeassistant-stubs";
  version = "2023.2.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KapJI";
    repo = "homeassistant-stubs";
    rev = "refs/tags/${version}";
    hash = "sha256-MQYk4DWvmqtPl00L1c00JclKkTZe9EYMrm/LucUHBE0=";
  };

  nativeBuildInputs = [
    poetry-core
    home-assistant
  ];

  pythonImportsCheck = [
    "homeassistant-stubs"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for Home Assistant Core";
    homepage = "https://github.com/KapJI/homeassistant-stubs";
    changelog = "https://github.com/KapJI/homeassistant-stubs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = teams.home-assistant.members;
  };
}
