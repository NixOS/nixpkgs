{ lib
, buildPythonPackage
, fetchPypi
, packaging
, pluggy
, py
, six
, virtualenv
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "tox";
  version = "3.2.1";

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ packaging pluggy py six virtualenv ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb61aa5bcce65325538686f09848f04ef679b5cd9b83cc491272099b28739600";
  };

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = https://tox.readthedocs.io/;
    license = licenses.mit;
  };
}
