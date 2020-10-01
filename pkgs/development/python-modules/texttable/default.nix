{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce0faf21aa77d806bbff22b107cc22cce68dc9438f97a2df32c93e9afa4ce436";
  };

  meta = with lib; {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = "https://github.com/foutaise/texttable";
    license = licenses.lgpl2;
  };
}
