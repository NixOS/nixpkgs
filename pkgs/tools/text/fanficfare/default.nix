{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "4.24.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DQaiP0EIvP0gT0b0nqJT18xqd5J5tuwIp6y7bpNH6tA=";
  };

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    chardet
    cloudscraper
    html5lib
    html2text
    requests-file
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
