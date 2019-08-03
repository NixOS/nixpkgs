{ lib
, buildPythonPackage
, fetchPypi
, notebook
, ipywidgets
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c9b4d73e388f2484296be18432d3cc0b8d59de243079a0db16a56c5571e1f86";
  };

  propagatedBuildInputs = [ notebook ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = http://ipython.org/;
    license = ipywidgets.meta.license; # Build from same repo
    maintainers = with lib.maintainers; [ fridh ];
  };
}