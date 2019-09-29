{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "text-unidecode";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14xb99fdv52j21dsljgsbmbaqv10ps4b453p229r29sdn4xn1mms";
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
