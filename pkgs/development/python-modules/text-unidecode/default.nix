{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytest,
}:

buildPythonPackage rec {
  pname = "text-unidecode";
  version = "1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Most basic Text::Unidecode port";
    homepage = "https://github.com/kmike/text-unidecode";
    license = lib.licenses.artistic1;
  };
}
