{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "fanficfare";
  version = "4.38.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E18svvnr9Wc1t8nU2akO2C055BwHb2GCKu4CT0tRhjA=";
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
    mainProgram = "fanficfare";
    homepage = "https://github.com/JimmXinu/FanFicFare";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dwarfmaster ];
  };
}
