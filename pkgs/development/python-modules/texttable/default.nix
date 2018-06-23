{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f75f5838b775bddc19f72c5bf50eb74be3815eb505ed3084e4666ce2e6c3259";
  };

  meta = {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = http://foutaise.org/code/;
    license = lib.licenses.lgpl2;
  };
}