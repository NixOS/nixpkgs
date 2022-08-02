{ lib, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "volatility";
  version = "unstable-2020-12-12";

  src = fetchFromGitHub {
    owner = "volatilityfoundation";
    repo = pname;
    rev = "a438e768194a9e05eb4d9ee9338b881c0fa25937";
    sha256 = "U/iWPztn47/Tcz/etVduG7V/Nu5Z1jb+i0mutaKr9sM=";
  };

  doCheck = false;
  pythonImportsCheck = [ "volatility" ];

  propagatedBuildInputs = with python2Packages; [
    pycrypto
    distorm3
    yara-python
    openpyxl
    # pillow is needed for the screenshot plugin but is marked insecure
    # pillow
  ];

  meta = with lib; {
    homepage = "https://www.volatilityfoundation.org/";
    description = "Advanced memory forensics framework";
    mainProgram = "vol.py";
    maintainers = with maintainers; [ bosu emilytrau ];
    license = lib.licenses.gpl2Plus;
  };
}
