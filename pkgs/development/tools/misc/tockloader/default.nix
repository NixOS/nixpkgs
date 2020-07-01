{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "tockloader";
  version = "1.4.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0l8mvlqzyq2bfb6g5zhgv2ndgyyrmpww2l7f2snbli73g6x5j2g2";
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

