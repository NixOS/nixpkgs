{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fastcore,
}:

buildPythonPackage {
  pname = "sqlite-minutils";
  version = "3.36.0.post4-unstable-2024-07-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "sqlite-minutils";
    rev = "5855737608069f017f0732f992d3d8a15dd7e197"; # no tag
    hash = "sha256-pK9pwPjtl8VAhDNPm+Ed6HL6CBBy2gkdOjmZWVKD/CY=";
  };

  build-system = [ setuptools ];

  dependencies = [ fastcore ];

  pythonImportsCheck = [ "sqlite_minutils" ];

  doCheck = false; # no tests

  meta = {
    description = "Fork of sqlite-utils with CLI etc removed";
    homepage = "https://github.com/AnswerDotAI/sqlite-minutils";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
