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
}:

buildPythonPackage rec {
  pname = "uvloop";
  version = "0.13.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0blcnrd5vky2k1m1p1skx4516dr1jx76yyb0c6fi82si6mqd0b4l";
  };

  buildInputs = [
    libuv
  ] ++ lib.optionals stdenv.isDarwin [ CoreServices ApplicationServices ];

  postPatch = ''
    # Removing code linting tests, which we don't care about
    rm tests/test_sourcecode.py
  '';

  checkInputs = [ pyopenssl psutil ];

  meta = with lib; {
    description = "Fast implementation of asyncio event loop on top of libuv";
    homepage = http://github.com/MagicStack/uvloop;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
