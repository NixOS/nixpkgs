{ lib
, buildPythonPackage
, fetchPypi
, jupyter-packaging
, notebook
, ipywidgets
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  version = "4.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6mfBenzUrjWPj0bDswTEBpi8BCNzLj8nMyHuFBIyyL4=";
  };

  nativeBuildInputs = [
    jupyter-packaging
  ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = "https://github.com/jupyter-widgets/ipywidgets/tree/master/python/widgetsnbextension";
    license = ipywidgets.meta.license; # Build from same repo
    maintainers = with lib.maintainers; [ fridh ];
  };
}
