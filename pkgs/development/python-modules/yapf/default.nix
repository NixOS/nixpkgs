{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yapf";
  version = "0.26.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "edb47be90a56ca6f3075fe24f119a22225fbd62c66777b5d3916a7e9e793891b";
  };

  meta = with stdenv.lib; {
    description = "A formatter for Python code.";
    homepage    = "https://github.com/google/yapf";
    license     = licenses.asl20;
    maintainers = with maintainers; [ siddharthist ];
  };

}
