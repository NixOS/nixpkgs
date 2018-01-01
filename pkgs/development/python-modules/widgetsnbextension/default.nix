{ lib
, buildPythonPackage
, fetchPypi
, notebook
, ipywidgets
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  name = "${pname}-${version}";
  version = "3.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a57e29e733b989e68fdd0f3d6927a3691763b39792591d573b95a89a5a12ec15";
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