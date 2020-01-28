{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pyopenssl
, libuv
, psutil
, isPy27
, pythonAtLeast
, CoreServices
, ApplicationServices
}:

buildPythonPackage rec {
  pname = "uvloop";
  version = "0.14.0";
  # python 3.8 hangs on tests, assuming it's subtly broken with race condition
  disabled = isPy27 || pythonAtLeast "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07j678z9gf41j98w72ysrnb5sa41pl5yxd7ib17lcwfxqz0cjfhj";
  };

  patches = lib.optional stdenv.isDarwin ./darwin_sandbox.patch;

  buildInputs = [
    libuv
  ] ++ lib.optionals stdenv.isDarwin [ CoreServices ApplicationServices ];

  postPatch = ''
    # Removing code linting tests, which we don't care about
    rm tests/test_sourcecode.py
  '';

  checkInputs = [ pyopenssl psutil ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Fast implementation of asyncio event loop on top of libuv";
    homepage = https://github.com/MagicStack/uvloop;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
