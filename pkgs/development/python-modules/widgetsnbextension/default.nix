{
  buildPythonPackage,
  fetchPypi,
  jupyter-packaging,
  ipywidgets,
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  version = "4.0.14";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o2KbBOPtuJMhLfhiA4xyMvYpczc4adtQhK7XObQ3ta8=";
  };

  nativeBuildInputs = [ jupyter-packaging ];

  pythonImportsCheck = [ "widgetsnbextension" ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = "https://github.com/jupyter-widgets/ipywidgets/tree/master/python/widgetsnbextension";
    license = ipywidgets.meta.license; # Build from same repo
  };
}
