{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.6.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KQNI+2f3dGkxvN/VWsdYTs1OWwhGqxZDM/B5SxIXYPI=";
  };

  meta = with lib; {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = "https://github.com/foutaise/texttable";
    license = licenses.lgpl2;
  };
}
