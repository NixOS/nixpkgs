{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "types-futures";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p00wb93af01b6fw9wxk9qm4kbhqwb48nszmm16slsrc1nx4px25";
  };

  meta = with lib; {
    description = "Typing stubs for futures";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
