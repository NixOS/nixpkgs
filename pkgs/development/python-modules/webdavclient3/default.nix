{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  python-dateutil,
  requests,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "webdavclient3";
  version = "3.14.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ezhov-evgeny";
    repo = "webdav-client-python-3";
    tag = "v${version}";
    hash = "sha256-vtZTBfq3PVrapv3ivYc18+71y7SPpJ+Mwk5qGe/DdTM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    python-dateutil
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "webdav3.client" ];

  disabledTestPaths = [
    # Tests require a local WebDAV instance
    "tests/test_client_it.py"
    "tests/test_client_resource_it.py"
    "tests/test_cyrilic_client_it.py"
    "tests/test_multi_client_it.py"
    "tests/test_tailing_slash_client_it.py"
  ];

  meta = {
    description = "Easy to use WebDAV Client for Python 3.x";
    homepage = "https://github.com/ezhov-evgeny/webdav-client-python-3";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "wdc";
  };
}
