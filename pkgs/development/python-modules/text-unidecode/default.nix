{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "text-unidecode";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-utZgO7FNJ5GTEHcUsoi+IGysVl36SapbEFKU3VxKq5M=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Most basic Text::Unidecode port";
    homepage = "https://github.com/kmike/text-unidecode";
    license = licenses.artistic1;
  };
}
