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
  version = "9.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "setuptools_scm";
    inherit version;
    hash = "sha256-RuHPfooJZSthP5uk/ptV8vSW56Iz5OANJafLQflMPAs=";
  };

  postPatch =
    if (pythonOlder "3.11") then
      ''
        substituteInPlace pyproject.toml \
          --replace-fail 'tomli<=2.0.2' 'tomli'
      ''
    else
      null;

  build-system = [ setuptools ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  dependencies = [
    packaging
    setuptools
    typing-extensions
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  optional-dependencies = {
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
