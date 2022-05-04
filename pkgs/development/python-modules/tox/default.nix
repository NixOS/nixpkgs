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
  version = "3.24.5";

  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ packaging pluggy py six virtualenv toml filelock ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "67e0e32c90e278251fea45b696d0fef3879089ccbe979b0c556d35d5a70e2993";
  };

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = "https://tox.readthedocs.io/";
    license = licenses.mit;
  };
}
