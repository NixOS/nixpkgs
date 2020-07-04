{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-websupport";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "33c0db6c0635b9dc3e72629b7278ca3b9fa24c156eeeaf1674be8f268831d951";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false;

  meta = {
    description = "Sphinx API for Web Apps";
    homepage = "http://sphinx-doc.org/";
    license = lib.licenses.bsd2;
  };
}
