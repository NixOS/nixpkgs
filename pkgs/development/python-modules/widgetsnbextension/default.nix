{ lib
, buildPythonPackage
, fetchPypi
, notebook
, ipywidgets
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  name = "${pname}-${version}";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "67fc28c3b9fede955d69bccbd92784e3f0c6d0dee3a71532cd3367c257feb178";
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