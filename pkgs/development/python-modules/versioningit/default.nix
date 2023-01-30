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
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c/KWXjDS6/1/+ra/JjaPIjdXBiLdKknH+8GZXenGdtY=";
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
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
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
