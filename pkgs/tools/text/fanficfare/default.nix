{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "4.25.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ky6N/AcfoXJahW7tw++WtnpTnpRv4ZUraMTWjVXDjEE=";
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
