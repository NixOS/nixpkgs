{ buildPythonPackage
, callPackage
, fetchPypi
, pythonOlder
, packaging
, typing-extensions
, tomli
, setuptools
, lib
}:

buildPythonPackage rec {
  pname = "setuptools-scm";
  version = "7.0.5";

  src = fetchPypi {
    pname = "setuptools_scm";
    inherit version;
    hash = "sha256-Ax4Tr3cdb4krlBrbbqBFRbv5Hrxc5ox4qvP/9uH7SEQ=";
  };

  # We need to remove importlib-metadata as a dependency when using Python 3.7
  # because it depends on setuptools_scm, and we build both from source.
  #
  # This still bootstraps because of:
  #
  #   https://github.com/pypa/setuptools_scm/pull/724
  #
  postPatch = lib.optionalString (pythonOlder "3.8") ''
    substituteInPlace setup.cfg --replace "importlib-metadata;python_version < '3.8'" ""
  '';

  propagatedBuildInputs = [
    packaging
    typing-extensions
    # Once 7.0.6+ of setuptools_scm is released, make tomli only a dependency
    # when Python < 3.11. See https://github.com/pypa/setuptools_scm/pull/748.
    tomli
    setuptools
  ];

  pythonImportsCheck = [
    "setuptools_scm"
  ];

  # check in passthru.tests.pytest to escape infinite recursion on pytest
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    homepage = "https://github.com/pypa/setuptools_scm/";
    description = "Handles managing your python package versions in scm metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
