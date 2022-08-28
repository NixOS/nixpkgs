{ lib
, buildPythonPackage
, fetchPypi
, ipywidgets
, jupyter-packaging
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  version = "4.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B/DoWC+SCyQxbO8WSQ8a60mPLIddSJgFQOXF2/D/Xi0=";
  };

  nativeBuildInputs = [
    jupyter-packaging
  ];

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
