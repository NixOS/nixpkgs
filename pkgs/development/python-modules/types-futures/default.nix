{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "types-futures";
  version = "3.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d286db818fb67e3ce5c28acd9058c067329b91865acc443ac3cf91497fa36f05";
  };

  meta = with lib; {
    description = "Typing stubs for futures";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
