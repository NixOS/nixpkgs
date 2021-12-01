{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-websupport";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1501befb0fdf1d1c29a800fdbf4ef5dc5369377300ddbdd16d2cd40e54c6eefc";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false;

  meta = {
    description = "Sphinx API for Web Apps";
    homepage = "http://sphinx-doc.org/";
    license = lib.licenses.bsd2;
  };
}
