{
  lib,
  buildPythonPackage,
  fetchPypi,
  jupyter-packaging,
  ipywidgets,
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  version = "4.0.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iyKo8ZEL/RiOWW/n/AXcvYfoEMikugEL2z2oZjc5hHQ=";
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
