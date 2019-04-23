{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "pirate-get";
  version = "0.3.3";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zwfgfiszkca44wlx5p2243hmf8594n7bnfva5if1f69dic6w7mi";
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
