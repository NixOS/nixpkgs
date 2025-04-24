{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
}:
buildPythonApplication rec {
  pname = "djhtml";
  version = "3.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rtts";
    repo = "djhtml";
    rev = "refs/tags/${version}";
    hash = "sha256-W93J3UFUrCqT718zoGcu96ORYFt0NLyYP7iVWbr8FYo=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "djhtml" ];

  meta = with lib; {
    homepage = "https://github.com/rtts/djhtml";
    description = "Django/Jinja template indenter";
    changelog = "https://github.com/rtts/djhtml/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "djhtml";
  };
}
