{ lib
, buildPythonPackage
, fetchPypi
, jupyter-packaging
, notebook
, ipywidgets
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  version = "4.0.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PB9eRtwRZt/UCkLWhealE5b9NP+Hh0Kj5HxvDMSio4U=";
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
