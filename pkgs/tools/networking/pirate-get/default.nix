{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "pirate-get";
  version = "0.3.1";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d7cc4b15dd8c6a82f9e03a666372e38613ccafdc846ad4c1226ba936beea68d";
  };

  propagatedBuildInputs = [ colorama veryprettytable beautifulsoup4 pyperclip ];

  meta = with stdenv.lib; {
    description = "A command line interface for The Pirate Bay";
    homepage = https://github.com/vikstrous/pirate-get;
    license = licenses.gpl1;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };
}
