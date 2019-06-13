{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2b60a5304ccfbeac80ffae7350d7c2f5d7a24e9aab5036d0f82489746419d9b2";
  };

  meta = {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = http://foutaise.org/code/;
    license = lib.licenses.lgpl2;
  };
}