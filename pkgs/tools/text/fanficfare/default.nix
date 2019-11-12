{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "3.12.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1hzb668fga9y422670iw22ggfn8a9jp2jdxs2xhzbqxnfrw08wq0";
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
