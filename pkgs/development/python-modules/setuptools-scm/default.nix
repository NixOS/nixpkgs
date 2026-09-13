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

buildPythonPackage (finalAttrs: {
  pname = "setuptools-scm";
  version = "10.0.5";
  pyproject = true;

  src = fetchPypi {
    pname = "setuptools_scm";
    inherit (finalAttrs) version;
    hash = "sha256-u7qP51RRbN79AX9EVnIXdebvlmK9eIf7Uq4mgT1IOMM=";
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

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/pypa/setuptools_scm/blob/${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://github.com/pypa/setuptools_scm/";
    description = "Handles managing your python package versions in scm metadata";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
