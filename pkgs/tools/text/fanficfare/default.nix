{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "4.8.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0h20cw9z6k3z42fhl48pfxcqrk3i45zp4f4xm6pz7jqjzi17h9fk";
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
