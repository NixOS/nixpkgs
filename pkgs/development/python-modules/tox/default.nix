{ lib
, buildPythonPackage
, fetchPypi
, py
, virtualenv
, pluggy
, setuptools_scm
, six
}:

buildPythonPackage rec {
  pname = "tox";
  version = "3.1.2";

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ py virtualenv pluggy six ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f0cbcc36e08c2c4ae90d02d3d1f9a62231f974bcbc1df85e8045946d8261059";
  };
}