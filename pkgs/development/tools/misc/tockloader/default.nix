{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "tockloader";
  version = "1.5.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "11k4ppwq845lnj265ydfr0cn1rrym5amx2i19x1h3ccbxc3gsy3x";
  };

  propagatedBuildInputs = with python3Packages; [
    argcomplete
    colorama
    crcmod
    pytoml
    pyserial
  ];

  meta = with lib; {
    homepage = "https://github.com/tock/tockloader";
    license = licenses.mit;
    description = "Tool for programming Tock onto hardware boards.";
    maintainers = with maintainers; [ hexa ];
  };
}

