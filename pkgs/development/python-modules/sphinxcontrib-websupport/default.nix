{ lib
, buildPythonPackage
, fetchPypi
, sphinxcontrib-serializinghtml
, six
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-websupport";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4edf0223a0685a7c485ae5a156b6f529ba1ee481a1417817935b20bde1956232";
  };

  propagatedBuildInputs = [ six sphinxcontrib-serializinghtml ];

  doCheck = false;

  meta = {
    description = "Sphinx API for Web Apps";
    homepage = "http://sphinx-doc.org/";
    license = lib.licenses.bsd2;
  };
}
