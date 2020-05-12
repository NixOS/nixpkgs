{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "3.19.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "01cr4941sg6is6k6sajlbr6hs5s47aq9xhp7gadhq4h3x6dilj40";
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
