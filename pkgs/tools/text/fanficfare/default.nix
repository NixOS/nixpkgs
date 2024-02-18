{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "4.31.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6AdiyL51UzK/f7wGn2UekAglGPIs4vfyYbC/MdD0aEk=";
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
