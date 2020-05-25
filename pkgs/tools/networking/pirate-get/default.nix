{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "pirate-get";
  version = "0.3.7";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i87g7f25dzsi5b3swr9gny2zpmrrgygxmr1ps71rjr1n540si9n";
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
