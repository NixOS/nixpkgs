{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z3xbijvhh86adg0jk5iv1jvga7cg25q1w12icb3snr5jim9sjv2";
  };

  meta = {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = http://foutaise.org/code/;
    license = lib.licenses.lgpl2;
  };
}