{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "text-unidecode";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l081m1w8ibbx684ca71ibdy68iwqsivy6rf6yqvysdclzldbbyh";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "The most basic Text::Unidecode port";
    homepage = https://github.com/kmike/text-unidecode;
    license = licenses.artistic1;
  };
}
