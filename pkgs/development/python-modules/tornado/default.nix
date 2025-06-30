{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,

  # for passthru.tests
  distributed,
  jupyter-server,
  jupyterlab,
  matplotlib,
  mitmproxy,
  pytest-tornado,
  pytest-tornasync,
  pyzmq,
  sockjs-tornado,
  urllib3,
}:

buildPythonPackage rec {
  pname = "tornado";
  version = "6.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tornadoweb";
    repo = "tornado";
    tag = "v${version}";
    hash = "sha256-CtmIjPKxKC0T8PGQW1wIAJm/+XxMzZXVZyZxV56sZME=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # additional tests that have extra dependencies, run slowly, or produce more output than a simple pass/fail
    # https://github.com/tornadoweb/tornado/blob/v6.2.0/maint/test/README
    "maint/test"

    # AttributeError: 'TestIOStreamWebMixin' object has no attribute 'io_loop'
    "tornado/test/iostream_test.py"
  ];

  disabledTests = [
    # Exception: did not get expected log message
    "test_unix_socket_bad_request"
  ];

  pythonImportsCheck = [ "tornado" ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit
      distributed
      jupyter-server
      jupyterlab
      matplotlib
      mitmproxy
      pytest-tornado
      pytest-tornasync
      pyzmq
      sockjs-tornado
      urllib3
      ;
  };

  meta = with lib; {
    description = "Web framework and asynchronous networking library";
    homepage = "https://www.tornadoweb.org/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
