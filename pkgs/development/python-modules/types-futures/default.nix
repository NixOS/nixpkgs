{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "types-futures";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbdad92cec642693bac10fbbecf834776009db7782d91dc293bdd123be73186d";
  };

  meta = with lib; {
    description = "Typing stubs for futures";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
