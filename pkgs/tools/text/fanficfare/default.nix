{ stdenv, fetchurl, python27Packages }:

python27Packages.buildPythonApplication rec {
  version = "2.27.0";
  name = "fanficfare-${version}";
  nameprefix = "";

  src = fetchurl {
    url = "https://github.com/JimmXinu/FanFicFare/archive/v${version}.tar.gz";
    sha256 = "02m1fr38hvxc1kby38xz9r75x5pcm8nly4d4ibnaf9i06xkg1pn0";
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
