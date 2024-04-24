{ lib
, fetchPypi
, buildPythonPackage
, docutils
}:

buildPythonPackage rec {
  pname = "statistics";
  version = "1.0.3.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2dc379b80b07bf2ddd5488cad06b2b9531da4dd31edb04dc9ec0dc226486c138";
  };

  propagatedBuildInputs = [ docutils ];

  # statistics package does not have any tests
  doCheck = false;

  meta = {
    description = "A Python 2.* port of 3.4 Statistics Module";
    homepage = "https://github.com/digitalemagine/py-statistics";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
