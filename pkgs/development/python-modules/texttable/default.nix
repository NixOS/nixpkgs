{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95e8cfe85f8395a7eacdfbc8f09d885b9ef3a6ac6ead0364ea721de1127aa36b";
  };

  meta = {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = http://foutaise.org/code/;
    license = lib.licenses.lgpl2;
  };
}