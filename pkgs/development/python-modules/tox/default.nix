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
  version = "3.24.4";

  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ packaging pluggy py six virtualenv toml filelock ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c30b57fa2477f1fb7c36aa1d83292d5c2336cd0018119e1b1c17340e2c2708ca";
  };

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = "https://tox.readthedocs.io/";
    license = licenses.mit;
  };
}
