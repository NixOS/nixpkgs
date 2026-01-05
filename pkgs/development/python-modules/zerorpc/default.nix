{
  lib,
  buildPythonPackage,
  fetchPypi,
  future,
  gevent,
  msgpack,
  pyzmq,
}:

buildPythonPackage rec {
  pname = "zerorpc";
  version = "0.6.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2ee247a566fc703f29c277d767f6f61f1e12f76d0402faea4bd815f32cbf37f";
  };

  propagatedBuildInputs = [
    future
    gevent
    msgpack
    pyzmq
  ];

  doCheck = false; # pypi version doesn't include tests

  meta = with lib; {
    description = "Easy to use, intuitive, and cross-language RPC";
    mainProgram = "zerorpc";
    homepage = "https://www.zerorpc.io";
    license = licenses.mit;
    maintainers = with maintainers; [ xeji ];
  };
}
