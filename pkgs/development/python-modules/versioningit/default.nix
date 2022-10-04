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
, pytest-mock
, git
, mercurial
}:

buildPythonPackage rec {
  pname = "versioningit";
  version = "2.0.1";
  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gJfiYNm99nZYW9gTO/e1//rDeox2KWJVtC2Gy1EqsuM=";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace "--cov=versioningit" "" \
      --replace "--cov-config=tox.ini" "" \
      --replace "--no-cov-on-fail" ""
  '';

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
    changelog = "https://versioningit.readthedocs.io/en/latest/changelog.html";
    license     = licenses.mit;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
