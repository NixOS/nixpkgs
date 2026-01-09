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
  version = "6.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tornadoweb";
    repo = "tornado";
    tag = "v${version}";
    hash = "sha256-jy/HnMY459yZX3HW9V61/ZSSanCJEZakBU/2pocGc/s=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # additional tests that have extra dependencies, run slowly, or produce more output than a simple pass/fail
    # https://github.com/tornadoweb/tornado/blob/v6.2.0/maint/test/README
    "maint/test"
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

  meta = {
    description = "Web framework and asynchronous networking library";
    homepage = "https://www.tornadoweb.org/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
