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
, tomli
, filelock
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tox";
  version = "3.27.1";

  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ packaging pluggy py six virtualenv filelock ]
                          ++ lib.optional (pythonOlder "3.11") tomli;

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sqkg41pmjMBpQv/RzzpPsiGk2QnKchkftthLCxinvgQ=";
  };

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = "https://tox.readthedocs.io/";
    license = licenses.mit;
  };
}
