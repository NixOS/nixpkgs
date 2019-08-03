{ lib
, buildPythonPackage
, fetchPypi
, pyopenssl
, libuv
, psutil
, isPy27
}:

buildPythonPackage rec {
  pname = "uvloop";
  version = "0.12.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c48692bf4587ce281d641087658eca275a5ad3b63c78297bbded96570ae9ce8f";
  };

  buildInputs = [ libuv ];

  checkInputs = [ pyopenssl psutil ];

  meta = with lib; {
    description = "Fast implementation of asyncio event loop on top of libuv";
    homepage = http://github.com/MagicStack/uvloop;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
