{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
}:
buildPythonApplication rec {
  pname = "djhtml";
  version = "3.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rtts";
    repo = "djhtml";
    tag = version;
    hash = "sha256-1bopV6mjwjXdoIN9i3An4NvSpeGcVlQ24nLLjP/UfQU=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "djhtml" ];

  meta = with lib; {
    homepage = "https://github.com/rtts/djhtml";
    description = "Django/Jinja template indenter";
    changelog = "https://github.com/rtts/djhtml/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "djhtml";
  };
}
