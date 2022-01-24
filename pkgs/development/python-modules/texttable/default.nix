{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42ee7b9e15f7b225747c3fa08f43c5d6c83bc899f80ff9bae9319334824076e9";
  };

  meta = with lib; {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = "https://github.com/foutaise/texttable";
    license = licenses.lgpl2;
  };
}
