{ lib
, python3Packages
, fetchFromGitHub
}:

with python3Packages; buildPythonApplication rec {
  pname = "tinyprog";
  # `python setup.py --version` from repo checkout
  version = "1.0.24.dev99+ga77f828";

  src = fetchFromGitHub {
    owner = "tinyfpga";
    repo = "TinyFPGA-Bootloader";
    rev = "a77f828d3d6ae077e323ec96fc3925efab5aa9d7";
    sha256 = "0jg47q0n1qkdrzri2q6n9a7czicj0qk58asz0xhzkajx1k9z3g5q";
  };

  sourceRoot = "source/programmer";

  propagatedBuildInputs = [
    pyserial
    jsonmerge
    intelhex
    tqdm
    six
    packaging
    pyusb
  ];

  nativeBuildInputs = [ setuptools_scm ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  meta = with lib; {
    homepage = https://github.com/tinyfpga/TinyFPGA-Bootloader/tree/master/programmer;
    description = "Programmer for FPGA boards using the TinyFPGA USB Bootloader";
    maintainers = with maintainers; [ emily ];
    license = licenses.asl20;
  };
}
