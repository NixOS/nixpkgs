{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
  setuptools,
  importlib-metadata,
  simplegeneric,
  netaddr,
  # Test inputs
  flask,
  flask-restful,
  pecan,
  sphinx,
  transaction,
  webtest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wsme";
  version = "0.12.1";
  pyproject = true;

  src = fetchPypi {
    pname = "WSME";
    inherit version;
    hash = "sha256-m36yJErzxwSskUte0iGVS7aK3QqLKy84okSwZ7M3mS0=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pbr ];

  dependencies = [
    importlib-metadata
    simplegeneric
    netaddr
  ];

  nativeCheckInputs = [
    pytestCheckHook
    flask
    flask-restful
    pecan
    sphinx
    transaction
    webtest
  ];

  enabledTestPaths = [
    "wsme/tests"
    "tests/pecantest"
    "tests/test_sphinxext.py"
    "tests/test_flask.py"
  ];

  meta = {
    description = "Simplify the writing of REST APIs, and extend them with additional protocols";
    homepage = "https://pythonhosted.org/WSME/";
    changelog = "https://pythonhosted.org/WSME/changes.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
