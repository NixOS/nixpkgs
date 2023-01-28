{ lib
, buildPythonPackage
, fetchPypi
, jupyter-packaging
, notebook
, ipywidgets
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  version = "4.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AD9xbZMNOFvj/Z3kLdm/AI4wBT9zvd3iNdFPvq7/Ga8=";
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
