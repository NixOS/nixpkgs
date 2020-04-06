{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pyopenssl
, libuv
, psutil
, isPy27
, CoreServices
, ApplicationServices
# Check Inputs
, pytestCheckHook
# , pytest-asyncio
}:

buildPythonPackage rec {
  pname = "uvloop";
  version = "0.14.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "07j678z9gf41j98w72ysrnb5sa41pl5yxd7ib17lcwfxqz0cjfhj";
  };

  patches = lib.optional stdenv.isDarwin ./darwin_sandbox.patch;

  buildInputs = [
    libuv
  ] ++ lib.optionals stdenv.isDarwin [ CoreServices ApplicationServices ];

  pythonImportsCheck = [
    "uvloop"
    "uvloop.loop"
  ];

  dontUseSetuptoolsCheck = true;
  checkInputs = [ pytestCheckHook pyopenssl psutil ];

  pytestFlagsArray = [
    # from pytest.ini, these are NECESSARY to prevent failures
    "--capture=no"
    "--assert=plain"
    "--tb=native"
    # ignore code linting tests
    "--ignore=tests/test_sourcecode.py"
  ];

  disabledTests = [
    "test_sock_cancel_add_reader_race"  # asyncio version of test is supposed to be skipped but skip doesn't happen. uvloop version runs fine
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

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Fast implementation of asyncio event loop on top of libuv";
    homepage = "https://github.com/MagicStack/uvloop";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
