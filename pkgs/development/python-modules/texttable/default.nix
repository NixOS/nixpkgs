{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mzv6zs8ciwnf83fwikqmmjwbzqmdja3imn4b4k209f80g0rk8qv";
  };

  meta = {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = http://foutaise.org/code/;
    license = lib.licenses.lgpl2;
  };
}