{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "3.15.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "12nsrl8nvg52mi136m7ayvaivwjapn7ry95137ynj1njy2w990hm";
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
    homepage = https://github.com/JimmXinu/FanFicFare;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dwarfmaster ];
    inherit version;
  };
}
