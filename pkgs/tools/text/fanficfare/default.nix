{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "3.21.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "16hklfbww6ibmjr32gg98nlnzl4dwanz6lm3fzg2x3vd7d54m92c";
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
