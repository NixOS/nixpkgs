{
  buildPythonPackage,
  fastjsonschema,
  fetchFromGitHub,
  lib,
  packaging,
  pytestCheckHook,
  pytest-cov,
  pytest-randomly,
  pytest-xdist,
  pythonOlder,
  setuptools,
  setuptools-scm,
  tomli,
  trove-classifiers,
  # validate-pyproject-schema-store,
}:

buildPythonPackage rec {
  pname = "validate-pyproject";
  version = "0.24.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "abravalheri";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-M6roHfa+u9rse41Cs664giOmz1MgRqPNGE8sMsJNFkw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fastjsonschema
  ];

  optional-dependencies = {
    all = [
      packaging
      tomli
      trove-classifiers
    ];
    # TODO
    # store = [
    #   validate-pyproject-schema-store
    # ];
  };

  nativeCheckInputs = [ pytestCheckHook ];
  checkInputs = [
    pytest-cov
    pytest-randomly
    pytest-xdist
    setuptools
    trove-classifiers
  ]
  ++ lib.optional (pythonOlder "3.11") tomli;
  # some tests are marked with uses_network, but nowhere near all of them.
  # current workaround: try to make http calls -> get skipped
  disabledMarkers = [
    "uses_network"
  ];
  disabledTests = [ "download" ];
  preCheck = ''
    cat << EOF >> tests/conftest.py

    def no_network_skip(*_, **__):
        pytest.skip()

    @pytest.fixture(autouse=True)
    def no_network(monkeypatch):
        monkeypatch.setattr("validate_pyproject.http.open_url", no_network_skip)
    EOF
  '';
  pythonImportsCheck = [ "validate_pyproject" ];

  meta = {
    description = "Validation library for simple check on `pyproject.toml";
    homepage = "https://github.com/abravalheri/validate-pyproject/";
    changelog = "https://github.com/abravalheri/validate-pyproject/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      jemand771
    ];
  };
}
