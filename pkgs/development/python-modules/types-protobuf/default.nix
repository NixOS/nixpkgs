{ buildPythonPackage, fetchPypi, lib, types-futures }:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "3.17.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f719a3f436a09d4a13411c9df1209e61b788dca64c6478fcd68e0ae5c5671283";
  };

  propagatedBuildInputs = [ types-futures ];

  meta = with lib; {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
