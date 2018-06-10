{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c89dc0148ae29645917aab7e970a30d1af565b3ca276cef8ab1a60469f0d8100";
  };

  meta = {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = http://foutaise.org/code/;
    license = lib.licenses.lgpl2;
  };
}