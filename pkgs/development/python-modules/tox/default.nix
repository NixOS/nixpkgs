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
  version = "2.9.1";

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ py virtualenv pluggy six ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "752f5ec561c6c08c5ecb167d3b20f4f4ffc158c0ab78855701a75f5cef05f4b8";
  };
}