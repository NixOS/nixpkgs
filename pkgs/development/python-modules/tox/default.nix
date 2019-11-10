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
  version = "3.14.0";

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ packaging pluggy py six virtualenv toml filelock ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c4f6b319c20ba4913dbfe71ebfd14ff95d1853c4231493608182f66e566ecfe1";
  };

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = https://tox.readthedocs.io/;
    license = licenses.mit;
  };
}
