{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "fanficfare";
  version = "4.35.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hPBURlsrr/7c26YFZo5UT7PTs8s+D8BXxjU/uposHjQ=";
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
