{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "text-unidecode";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "The most basic Text::Unidecode port";
    homepage = "https://github.com/kmike/text-unidecode";
    license = licenses.artistic1;
  };
}
