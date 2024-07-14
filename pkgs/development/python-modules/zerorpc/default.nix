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
    hash = "sha256-0u4kelZvxwPynCd9dn9vYfHhL3bQQC+upL2BXzLL838=";
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
