{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, importlib-metadata
, packaging
, setuptools
, tomli
, pytestCheckHook
, build
, pydantic
, pytest-cov
, pytest-mock
, git
, mercurial
}:

buildPythonPackage rec {
  pname = "versioningit";
  version = "1.1.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-O3VlotuS8SBrW4M6csxpNsinTWXpQiTwqetUeZ0VYdk=";
  };

  format = "pyproject";

  propagatedBuildInputs = [
    packaging
    setuptools
    tomli
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
    build
    pydantic
    pytest-cov
    pytest-mock
    git
    mercurial
  ];

  disabledTests = [
    # wants to write to the Nix store
    "test_editable_mode"
  ];

  pythonImportsCheck = [
    "versioningit"
  ];

  meta = with lib; {
    description = "setuptools plugin for determining package version from VCS";
    homepage = "https://github.com/jwodder/versioningit";
    license     = licenses.mit;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
