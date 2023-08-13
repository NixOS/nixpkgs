{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook

# for passthru.tests
, distributed
, jupyter-server
, jupyterlab
, matplotlib
, mitmproxy
, pytest-tornado
, pytest-tornasync
, pyzmq
, sockjs-tornado
, urllib3
}:

buildPythonPackage rec {
  pname = "tornado";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "tornadoweb";
    repo = "tornado";
    rev = "v${version}";
    hash = "sha256-IV0QN3GqoclFo9kWJVc21arypmBkvUClo86Zmt/Gv6E=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-28370.patch";
      url = "https://github.com/tornadoweb/tornado/commit/32ad07c54e607839273b4e1819c347f5c8976b2f.patch";
      hash = "sha256-2dpPHkNThOaZD8T2g1vb/I5WYZ/vy/t690539uprJyc=";
    })
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
      urllib3;
  };

  meta = with lib; {
    description = "A web framework and asynchronous networking library";
    homepage = "https://www.tornadoweb.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
