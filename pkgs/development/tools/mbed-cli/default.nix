{ lib, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "mbed-cli";
  version = "1.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04vn2v0d7y3vmm8cswzvn2z85balgp3095n5flvgf3r60fdlhlmp";
  };

  doCheck = false; # no tests available in Pypi

  meta = with lib; {
    homepage = https://github.com/ARMmbed/mbed-cli;
    description = "Arm Mbed Command Line Interface";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}

