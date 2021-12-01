{ lib
, buildPythonPackage
, fetchPypi
, notebook
, ipywidgets
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  version = "3.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "079f87d87270bce047512400efd70238820751a11d2d8cb137a5a5bdbaf255c7";
  };

  propagatedBuildInputs = [ notebook ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = "http://ipython.org/";
    license = ipywidgets.meta.license; # Build from same repo
    maintainers = with lib.maintainers; [ fridh ];
  };
}
