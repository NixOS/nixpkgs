{ lib, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "pirate-get";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07s5ss9dxccx1mip7pyga1fagywkqchxmzz55ng47ac9053ffxkq";
  };

  propagatedBuildInputs = [ colorama veryprettytable pyperclip ];

  meta = with lib; {
    description = "A command line interface for The Pirate Bay";
    homepage = "https://github.com/vikstrous/pirate-get";
    license = licenses.gpl1;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };
}
