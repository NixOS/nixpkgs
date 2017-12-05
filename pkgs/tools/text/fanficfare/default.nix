{ stdenv, fetchurl, python27Packages }:

python27Packages.buildPythonApplication rec {
  version = "2.16.0";
  name = "fanficfare-${version}";
  nameprefix = "";

  src = fetchurl {
    url = "https://github.com/JimmXinu/FanFicFare/archive/v${version}.tar.gz";
    sha256 = "0c31z7w4b3wz5nahsmnfhvp3srprfsqbp3zyngw4cqw3dm17kvvi";
  };

  propagatedBuildInputs = with python27Packages; [ beautifulsoup4 chardet html5lib html2text ];

  meta = with stdenv.lib; {
    description = "FanFicFare is a tool for making eBooks from fanfiction web sites";
    homepage = https://github.com/JimmXinu/FanFicFare;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lucas8 ];
    inherit version;
  };
}
