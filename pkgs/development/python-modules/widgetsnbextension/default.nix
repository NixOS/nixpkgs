{ lib
, buildPythonPackage
, fetchPypi
, notebook
, ipywidgets
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  name = "${pname}-${version}";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "566582a84642d0c0f78b756a954450a38a8743eeb8dad04b7cab3ca66f455e6f";
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