{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "types-futures";
  version = "3.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f47bf00704ef8ff05726a7e86fcf0986de998992fbdd880986121baa8b7184bf";
  };

  meta = with lib; {
    description = "Typing stubs for futures";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
