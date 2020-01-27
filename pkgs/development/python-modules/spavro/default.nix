{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "spavro";
  version = "1.1.22";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "14f3643cb17dfa5550dc20e114c56c92c31408c050726f5429ccbcedda60fc79";
  };
  
  propagatedBuildInputs = [ six ];
  
  meta = with lib; {
    description = "(SP)eedier AVRO implementation using Cython";
    homepage = "http://github.com/pluralsight/spavro";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
