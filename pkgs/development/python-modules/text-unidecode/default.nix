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
    hash = "sha256-utZgO7FNJ5GTEHcUsoi+IGysVl36SapbEFKU3VxKq5M=";
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
