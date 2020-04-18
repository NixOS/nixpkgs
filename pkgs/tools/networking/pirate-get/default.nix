{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "pirate-get";
  version = "0.3.5";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "01jr9c04ic4bfalfdijavzvqzmpkw3hq1glqyc86z3v6zwl8dlp2";
  };

  propagatedBuildInputs = [ colorama veryprettytable beautifulsoup4 pyperclip ];

  meta = with stdenv.lib; {
    description = "A command line interface for The Pirate Bay";
    homepage = "https://github.com/vikstrous/pirate-get";
    license = licenses.gpl1;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };
}
