{ lib
, buildPythonPackage
, fetchPypi
, notebook
, ipywidgets
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  version = "3.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6Ep6n8ubrz1XEG4YSnOJqPjrk1v3QaXrnWCqGMwCmoA=";
  };

  # setup.py claims to require notebook, but the source doesn't have any imports
  # in it.
  postPatch = ''
    substituteInPlace setup.py --replace "'notebook>=4.4.1'," ""
  '';

  propagatedBuildInputs = [ ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = "http://ipython.org/";
    license = ipywidgets.meta.license; # Build from same repo
    maintainers = with lib.maintainers; [ fridh ];
  };
}
