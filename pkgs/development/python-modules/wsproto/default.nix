{ buildPythonPackage, fetchPypi, h11, enum34 }:

buildPythonPackage rec {
  pname = "wsproto";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fcb726d448f1b9bcbea884e26621af5ddd01d2d502941a024f4c727828b6009";
  };

  propagatedBuildInputs = [ h11 enum34 ];

}
