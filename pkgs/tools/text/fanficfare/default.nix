{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "3.16.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1l76fh23a9wmw47bahd5l1bxyqcy54lahvid373iy9p3586fskis";
  };

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    chardet
    html5lib
    html2text
  ];

  doCheck = false; # no tests exist

  meta = with stdenv.lib; {
    description = "Tool for making eBooks from fanfiction web sites";
    homepage = "https://github.com/JimmXinu/FanFicFare";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dwarfmaster ];
    inherit version;
  };
}
