{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  vcs-versioning,

  # optional-dependencies
  rich,
}:

buildPythonPackage rec {
  pname = "setuptools-scm";
  version = "10.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "setuptools_scm";
    inherit version;
    hash = "sha256-T6fdgs+MgA31nJoojJApmxZX/x7Pw/XMACh8Xb9eJ6k=";
  };

  postPatch = null;

  build-system = [ setuptools ];

  dependencies = [
    setuptools
    vcs-versioning
  ];

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

  meta = {
    changelog = "https://github.com/pypa/setuptools_scm/blob/${version}/CHANGELOG.md";
    homepage = "https://github.com/pypa/setuptools_scm/";
    description = "Handles managing your python package versions in scm metadata";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
