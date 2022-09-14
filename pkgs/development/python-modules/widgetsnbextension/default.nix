{ lib
, buildPythonPackage
, fetchPypi
, notebook
, ipywidgets
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  version = "4.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NIJIZMBisLMDCteCENta5qOWDfth1bJ1YtZjF3TeAoY=";
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
