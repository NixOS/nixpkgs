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
  version = "3.0.0";

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ py virtualenv pluggy six ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "96efa09710a3daeeb845561ebbe1497641d9cef2ee0aea30db6969058b2bda2f";
  };
}