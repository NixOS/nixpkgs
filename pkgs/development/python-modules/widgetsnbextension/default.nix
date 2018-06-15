{ lib
, buildPythonPackage
, fetchPypi
, notebook
, ipywidgets
}:

buildPythonPackage rec {
  pname = "widgetsnbextension";
  name = "${pname}-${version}";
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5417789ee6064ff515fd10be24870660af3561c02d3d48b26f6f44285d0f70cc";
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