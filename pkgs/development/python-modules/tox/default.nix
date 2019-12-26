{ lib
, buildPythonPackage
, fetchPypi
, packaging
, pluggy
, py
, six
, virtualenv
, setuptools_scm
, toml
, filelock
}:

buildPythonPackage rec {
  pname = "tox";
  version = "3.14.2";

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ packaging pluggy py six virtualenv toml filelock ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7efd010a98339209f3a8292f02909b51c58417bfc6838ab7eca14cf90f96117a";
  };

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = https://tox.readthedocs.io/;
    license = licenses.mit;
  };
}
