{ lib, python27Packages }:

python27Packages.buildPythonApplication rec {
  pname = "symbolator";
  version = "1.0.2";

  src = python27Packages.fetchPypi {
    inherit pname version;
    sha256 = "cb25c11443536bdd9a998ed2245e143c406591b96ed236d2f2c43941f566752a";
  };

  #This module does not contain any tests.
  doCheck = false;

  buildInputs = with python27Packages; [ setuptools ];

  propagatedBuildInputs = with python27Packages; [
    pygtk
    sphinx
    pycairo
    hdlparse
  ];

  meta = with lib; {
    homepage = "https://kevinpt.github.io/symbolator/";
    description = "A component diagramming tool for VHDL and Verilog";
    license = licenses.mit;
    maintainers = with maintainers; [ elliottvillars ];
  };
}
