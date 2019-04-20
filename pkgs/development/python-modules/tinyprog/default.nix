{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, intelhex
, jsonmerge
, packaging  
, pyserial
, pyusb
, six
, tqdm
}:

buildPythonPackage rec {
  pname = "tinyprog";
  version = "1.0.21";
  format = "wheel";

  src = fetchPypi ({
    inherit pname version format;
  } // (if isPy3k then {
    python = "py3";
    sha256 = "f347e97a0f2cd67b6cc0331f6b64b284c45e644e12cd4183fa84919c1ea0e151";
  } else {
    python = "py2";
    sha256 = "1987dffe4d17e9bdb03db17e70a0a0e713b2b8c3a523b57ecc8b1bd5e9091a68";  
  }));

  propagatedBuildInputs = [ pyusb tqdm six jsonmerge pyserial intelhex packaging ];

  meta = with stdenv.lib; {
    description = "Programmer for FPGA boards using the TinyFPGA USB Bootloader";
    homepage = "https://github.com/tinyfpga/TinyFPGA-Bootloader/";
    license = licenses.gpl3;
  };
}
