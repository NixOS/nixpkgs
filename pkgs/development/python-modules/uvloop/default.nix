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
  version = "0.15.2";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2bb0624a8a70834e54dde8feed62ed63b50bad7a1265c40d6403a2ac447bce01";
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
