{ lib
, buildPythonPackage
, fetchPypi
, packaging
, pluggy
, py
, six
, virtualenv
, setuptools-scm
, toml
, filelock
}:

buildPythonPackage rec {
  pname = "tox";
  version = "3.24.3";

  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ packaging pluggy py six virtualenv toml filelock ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6c4e77705ada004283610fd6d9ba4f77bc85d235447f875df9f0ba1bc23b634";
  };

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = "https://tox.readthedocs.io/";
    license = licenses.mit;
  };
}
