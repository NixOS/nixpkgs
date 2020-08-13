{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-websupport";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee1d43e6e0332558a66fcb4005b9ba7313ad9764d0df0e6703ae869a028e451f";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false;

  meta = {
    description = "Sphinx API for Web Apps";
    homepage = "http://sphinx-doc.org/";
    license = lib.licenses.bsd2;
  };
}
