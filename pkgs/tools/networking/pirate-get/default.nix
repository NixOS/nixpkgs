{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "pirate-get";
  version = "0.3.2";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1iirip12zrxm2nqsib5wfqqnlfmhh432y3kkyih9crk4q2p914df";
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
