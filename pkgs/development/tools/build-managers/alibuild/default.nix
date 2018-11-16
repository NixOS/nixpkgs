{ stdenv, lib, python}:

python.pkgs.buildPythonApplication rec {
  pname = "alibuild";
  version = "1.5.4rc3";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1mnh0h9m96p78b9ln1gbl4lw1mgl16qbyfi9fj2l13p3nxaq1sib";
  };

  argparse = null;

  doCheck = false;
  propagatedBuildInputs = [
    python.pkgs.requests
    python.pkgs.argparse
    python.pkgs.pyyaml
  ];

  meta = with lib; {
    homepage = "https://alisw.github.io/alibuild/";
    description = "Build tool for ALICE experiment software";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ktf ];
  };
}
