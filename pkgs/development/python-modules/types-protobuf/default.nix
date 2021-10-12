{ buildPythonPackage, fetchPypi, lib, types-futures }:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "3.17.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r42kzspqna2b2jiz9bjzagrd4gbh0sd6jp4v7i9nv09y0ifrkrn";
  };

  propagatedBuildInputs = [ types-futures ];

  meta = with lib; {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
