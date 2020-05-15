{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yapf";
  version = "0.29.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "712e23c468506bf12cadd10169f852572ecc61b266258422d45aaf4ad7ef43de";
  };

  meta = with stdenv.lib; {
    description = "A formatter for Python code.";
    homepage    = "https://github.com/google/yapf";
    license     = licenses.asl20;
    maintainers = with maintainers; [ siddharthist ];
  };

}
