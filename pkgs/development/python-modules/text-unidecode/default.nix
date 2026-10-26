{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "text-unidecode";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-utZgO7FNJ5GTEHcUsoi+IGysVl36SapbEFKU3VxKq5M=";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Most basic Text::Unidecode port";
    homepage = "https://github.com/kmike/text-unidecode";
    license = lib.licenses.artistic1;
  };
})
