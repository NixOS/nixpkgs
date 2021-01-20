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
  version = "3.20.1";

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ packaging pluggy py six virtualenv toml filelock ];

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4321052bfe28f9d85082341ca8e233e3ea901fdd14dab8a5d3fbd810269fbaf6";
  };

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = "https://tox.readthedocs.io/";
    license = licenses.mit;
  };
}
