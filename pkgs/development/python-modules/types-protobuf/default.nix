{ buildPythonPackage, fetchPypi, lib, types-futures }:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "3.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a391d1a9138fe53fe08aeb6aa15ca7f1a188659b9a6c12af5313c55730eccd6c";
  };

  propagatedBuildInputs = [ types-futures ];

  meta = with lib; {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
