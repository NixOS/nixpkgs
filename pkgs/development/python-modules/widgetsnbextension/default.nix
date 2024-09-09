{
  buildPythonPackage,
  fetchPypi,
  jupyter-packaging,
  ipywidgets,
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  version = "4.0.13";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/8tnvJ/r0QI0o2J5X2Q5J/TgwF2TQscntl0jhPj+rLY=";
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
