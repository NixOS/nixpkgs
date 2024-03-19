{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "4.32.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qfe24Ees3LLnSuU4kjn+dwtKjLBSYgF22U1YAtpw1po=";
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
