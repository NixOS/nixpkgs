{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
<<<<<<< HEAD

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
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "tornado";
<<<<<<< HEAD
  version = "6.3.3";
=======
  version = "6.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tornadoweb";
    repo = "tornado";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-l9Ce/c2wDSmsySr9yXu5Fl/+63QkQay46aDSUTJmetA=";
=======
    hash = "sha256-IV0QN3GqoclFo9kWJVc21arypmBkvUClo86Zmt/Gv6E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

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

<<<<<<< HEAD
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

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A web framework and asynchronous networking library";
    homepage = "https://www.tornadoweb.org/";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
