{ lib
, buildPythonPackage
, fetchPypi
, notebook
, ipywidgets
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  name = "${pname}-${version}";
  version = "3.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02edabcaeaa247721df8027f660f3384c20f30c4865a7ea5dd80685c368736df";
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