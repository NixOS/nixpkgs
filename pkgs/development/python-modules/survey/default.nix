{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "survey";
  version = "5.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i6l1elywi37J+RZR9kv2JFsty/g1N0iiE9ZUOdKuqKY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  doCheck = false;
  pythonImportsCheck = [ "survey" ];

  meta = with lib; {
    description = "Simple library for creating beautiful interactive prompts";
    homepage = "https://github.com/Exahilosys/survey";
    changelog = "https://github.com/Exahilosys/survey/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
