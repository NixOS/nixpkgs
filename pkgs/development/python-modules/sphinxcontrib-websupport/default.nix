{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-websupport";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9de47f375baf1ea07cdb3436ff39d7a9c76042c10a769c52353ec46e4e8fc3b9";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false;

  meta = {
    description = "Sphinx API for Web Apps";
    homepage = http://sphinx-doc.org/;
    license = lib.licenses.bsd2;
  };
}