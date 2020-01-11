{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "texttable";
  version = "1.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x5l77akfc20x52jma9573qp8l8r07q103pm4l0pbizvh4vp1wzg";
  };

  meta = with lib; {
    description = "A module to generate a formatted text table, using ASCII characters";
    homepage = "https://github.com/foutaise/texttable";
    license = licenses.lgpl2;
  };
}
