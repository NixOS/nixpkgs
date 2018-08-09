{ stdenv, python3 }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "scour";
  version = "0.37";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05k1f8i8v7sp5v39lian865vwvapq05a6vmvk7fwnxv8kivi6ccn";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "An SVG Optimizer / Cleaner ";
    homepage    = https://github.com/scour-project/scour;
    license     = licenses.asl20;
    maintainers = with maintainers; [ worldofpeace ];
    platforms   = platforms.unix;
  };
}
