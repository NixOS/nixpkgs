{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  packaging,
  typing-extensions,
  tomli,

  # optional-dependencies
  rich,
}:

buildPythonPackage rec {
  pname = "setuptools-scm";
  version = "8.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tfQ/9oAGaVlRk/0JiRVk7p0dfcsZbKtLJQbVOi4clcc=";
  };

  nativeBuildInputs = [ setuptools ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  propagatedBuildInputs = [
    packaging
    setuptools
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  passthru.optional-dependencies = {
    rich = [ rich ];
  };

  pythonImportsCheck = [ "setuptools_scm" ];

  # check in passthru.tests.pytest to escape infinite recursion on pytest
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    changelog = "https://github.com/pypa/setuptools_scm/blob/${version}/CHANGELOG.md";
    homepage = "https://github.com/pypa/setuptools_scm/";
    description = "Handles managing your python package versions in scm metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
