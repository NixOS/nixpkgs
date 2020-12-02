{ stdenv
, pkgs
, fetchFromGitHub
, buildPythonPackage
, textx
}:

buildPythonPackage rec {
  pname = "symbiflow-fasm";
  version = "0.0.1-g4857dde";

  src = fetchFromGitHub {
    owner = "SymbiFlow";
    repo = "fasm";
    rev = "4857dde757edd88688c2faf808774d85bdbe3900";
    sha256 = "1za7f8slf8wvp1mfbfc3vdv61115p49k0vwngs4db6ips1qg1435";
  };

  propagatedBuildInputs = [ textx ];

  meta = with stdenv.lib; {
    description = "FPGA Assembly (FASM) Parser and Generation library";
    homepage = "https://github.com/SymbiFlow/fasm";
    license = licenses.isc;
    maintainers = with maintainers; [ mcaju ];
  };
}
