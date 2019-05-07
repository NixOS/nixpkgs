{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "3.7.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1h4a1y9m65lf495r52gayprlbxpd43hpbhcbawadbkxf26gr1vkk";
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
    maintainers = with maintainers; [ lucas8 ];
    inherit version;
  };
}
