{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, libuv
, CoreServices
, ApplicationServices
# Check Inputs
, aiohttp
, psutil
, pyopenssl
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "uvloop";
  version = "0.15.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p33xfzcy60qqca3rplzbh8h4x7x9l77vi6zbyy9md5z2a0q4ikq";
  };

  buildInputs = [
    libuv
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
    ApplicationServices
  ];

  dontUseSetuptoolsCheck = true;
  checkInputs = [
    aiohttp
    pytestCheckHook
    pyopenssl
    psutil
  ];

  pytestFlagsArray = [
    # from pytest.ini, these are NECESSARY to prevent failures
    "--capture=no"
    "--assert=plain"
    "--strict"
    "--tb=native"
    # ignore code linting tests
    "--ignore=tests/test_sourcecode.py"
  ];

  # force using installed/compiled uvloop vs source by moving tests to temp dir
  preCheck = ''
    export TEST_DIR=$(mktemp -d)
    cp -r tests $TEST_DIR
    pushd $TEST_DIR
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [
    "uvloop"
    "uvloop.loop"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Fast implementation of asyncio event loop on top of libuv";
    homepage = "https://github.com/MagicStack/uvloop";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
