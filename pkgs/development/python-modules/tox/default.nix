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
  version = "3.23.1";

  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ packaging pluggy py six virtualenv toml filelock ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "307a81ddb82bd463971a273f33e9533a24ed22185f27db8ce3386bff27d324e3";
  };

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = "https://tox.readthedocs.io/";
    license = licenses.mit;
  };
}
