{ lib
, buildPythonPackage
, fetchPypi
, packaging
, pluggy
, py
, python
, six
, virtualenv
, setuptools-scm
, tomli
, filelock
}:

buildPythonPackage rec {
  pname = "tox";
  version = "3.26.0";

  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ packaging pluggy py six virtualenv filelock ]
    ++ lib.optionals (python.pythonOlder "3.11") [ tomli ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RPPDR8aMLGh5nX1E8YCPnTlvyKGlAMvGJCUzdceuEH4=";
  };

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = "https://tox.readthedocs.io/";
    license = licenses.mit;
  };
}
