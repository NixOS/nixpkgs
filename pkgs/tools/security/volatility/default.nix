{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "volatility";
  version = "unstable-2022-01-10";

  src = fetchFromGitHub {
    owner = "koromodako";
    repo = pname;
    rev = "923c7160b008753873fa47d82a49b190814eb92e";
    hash = "sha256-m6LUXOawDXCmyuC2wWtGL9V6MO3SgbyrfIetKcTdwBQ=";
  };

  propagatedBuildInputs = with python3Packages; [ pycrypto distorm3 pillow ];

  meta = with lib; {
    homepage = "https://www.volatilityfoundation.org/";
    description = "Advanced memory forensics framework";
    maintainers = with maintainers; [ bosu ];
    license = lib.licenses.gpl2Plus;
  };
}
