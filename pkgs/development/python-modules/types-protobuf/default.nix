{ buildPythonPackage, fetchPypi, lib, types-futures }:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "3.18.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6696bf3cabc51dcc076e8de025c405dbdea7488c5268c2febd14527dac82c233";
  };

  propagatedBuildInputs = [ types-futures ];

  meta = with lib; {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
