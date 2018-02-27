{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "text-unidecode";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a1375bb2ba7968740508ae38d92e1f889a0832913cb1c447d5e2046061a396d";
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
