{ lib, buildPythonPackage, fetchPypi, future, gevent, msgpack-python, pyzmq }:

buildPythonPackage rec {
  pname = "zerorpc";
  version = "0.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14d0nmprs0nm17d8kg2f7qalsi8x7c4damsccqgncylj7mpnk9hh";
  };

  propagatedBuildInputs = [ future gevent msgpack-python pyzmq ];

  doCheck = false; # pypi version doesn't include tests

  meta = with lib; {
    description = "An easy to use, intuitive, and cross-language RPC";
    homepage = "https://www.zerorpc.io";
    license = licenses.mit;
    maintainers = with maintainers; [ xeji ];
  };
}
