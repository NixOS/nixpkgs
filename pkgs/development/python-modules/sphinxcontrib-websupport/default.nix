{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-websupport";
  version = "1.0.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a85961326aa3a400cd4ad3c816d70ed6f7c740acd7ce5d78cd0a67825072eb9";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false;

  meta = {
    description = "Sphinx API for Web Apps";
    homepage = http://sphinx-doc.org/;
    license = lib.licenses.bsd2;
  };
}