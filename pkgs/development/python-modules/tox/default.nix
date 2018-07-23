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
  version = "3.1.2";

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ packaging pluggy py six virtualenv ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f0cbcc36e08c2c4ae90d02d3d1f9a62231f974bcbc1df85e8045946d8261059";
  };

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = https://tox.readthedocs.io/;
    license = licenses.mit;
  };
}
