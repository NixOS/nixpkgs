{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  packaging,
  tomli,
  pytestCheckHook,
  build,
  hatchling,
  pydantic,
  pytest-cov-stub,
  pytest-mock,
  setuptools,
  gitMinimal,
  mercurial,
}:

buildPythonPackage rec {
  pname = "versioningit";
  version = "3.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uRrX1z5z0hIg5pVA8gIT8rcpofmzXATp4Tfq8o0iFNo=";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace-fail "ignore:.*No source for code:coverage.exceptions.CoverageWarning" ""
  '';

  build-system = [ hatchling ];

  dependencies = [
    packaging
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    pytestCheckHook
    build
    hatchling
    pydantic
    pytest-cov-stub
    pytest-mock
    setuptools
    gitMinimal
    mercurial
  ];

  disabledTests = [
    # wants to write to the Nix store
    "test_editable_mode"
    # network access
    "test_install_from_git_url"
    "test_install_from_zip_url"
  ];

  pythonImportsCheck = [ "versioningit" ];

  meta = with lib; {
    description = "Setuptools plugin for determining package version from VCS";
    mainProgram = "versioningit";
    homepage = "https://github.com/jwodder/versioningit";
    changelog = "https://versioningit.readthedocs.io/en/latest/changelog.html";
    license = licenses.mit;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
