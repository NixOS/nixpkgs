{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "4.30.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bUJWpl0sBN7ljr1tPDW2a346NsgLhWexl/kzdXTki1o=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    brotli
    chardet
    cloudscraper
    html5lib
    html2text
    requests
    requests-file
    urllib3
  ];

  doCheck = false; # no tests exist

  meta = with lib; {
    description = "Tool for making eBooks from fanfiction web sites";
    homepage = "https://github.com/JimmXinu/FanFicFare";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dwarfmaster ];
  };
}
