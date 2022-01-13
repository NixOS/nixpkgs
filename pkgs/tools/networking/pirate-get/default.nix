{ lib, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "pirate-get";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pr703fwinr2f4rba86zp57mpf5j2jgvp5n50rc5vy5g7yfwsddm";
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
