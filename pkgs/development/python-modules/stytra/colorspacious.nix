{ lib, pkgs, buildPythonPackage, fetchPypi, isPy3k
, numpy
}:

buildPythonPackage rec {
  pname = "colorspacious";
  version = "1.1.2";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    sha256 = "c78befa603cea5dccb332464e7dd29e96469eebf6cd5133029153d1e69e3fd6f";
  };

  propagatedBuildInputs = [
    numpy
  ];

  meta = {
    homepage = "https://github.com/njsmith/colorspacious";
    description = "A powerful, accurate, and easy-to-use Python library for doing colorspace conversions ";
    license = lib.licenses.mit;
    maintainer = with lib.maintainers; [ tbenst ];
  };
}
