{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "FanFicFare";
  version = "3.17.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1h7kzlw516w9qk5vcn0rqibxbhvzbmxgnf9l6yjxj30x53ynrvzj";
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
