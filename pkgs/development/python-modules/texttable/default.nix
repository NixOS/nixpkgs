{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44674d1d470a9fc264c4d1eba44b74463ca0066d7b954453dd5a4f8057779c9c";
  };

  meta = {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = http://foutaise.org/code/;
    license = lib.licenses.lgpl2;
  };
}