{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  requests,
  ndjson,
  flask,
  importlib-metadata,
  swh-core,
  swh-model,
  swh-auth,
  swh-web-client,
  beautifulsoup4,
  pytestCheckHook,
  pytest-flask,
  pytest-mock,
  types-beautifulsoup4,
  types-pyyaml,
  types-requests,
}:

buildPythonPackage rec {
  pname = "swh-scanner";
  version = "0.8.3";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-scanner";
    tag = "v${version}";
    hash = "sha256-baUUuYFapBD7iuDaDP8CSR9f4glVZcS5qBpZddVf7z8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    requests
    ndjson
    flask
    importlib-metadata
    swh-core
    swh-model
    swh-auth
    swh-web-client
  ];

  pythonImportsCheck = [ "swh.scanner" ];

  nativeCheckInputs = [
    beautifulsoup4
    pytestCheckHook
    pytest-flask
    pytest-mock
    swh-core
    swh-model
    types-beautifulsoup4
    types-pyyaml
    types-requests
  ];

  disabledTestPaths = [
    # pytestRemoveBytecodePhase fails with: "error (ignored): error: opening directory "/tmp/nix-build-python3.12-swh-scanner-0.8.3.drv-5/build/pytest-of-nixbld/pytest-0/test_randomdir_policy_info_cal0/big-directory/dir/dir/dir/ ......"
    "swh/scanner/tests/test_policy.py"
    # TypeError: CliRunner.__init__() got an unexpected keyword argument 'mix_stderr'
    "swh/scanner/tests/test_cli.py"
  ];

  meta = {
    changelog = "https://gitlab.softwareheritage.org/swh/devel/swh-scanner/-/tags/${src.tag}";
    description = "Source code scanner to analyze code bases and compare them with source code artifacts archived by Software Heritage";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-scanner";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
