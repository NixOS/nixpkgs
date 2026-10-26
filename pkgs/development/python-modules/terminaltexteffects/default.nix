{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "terminaltexteffects";
  version = "0.15.0";
  pyproject = true;

  # no tests on pypi, no tags on github
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9LMchr+pQ9W/Oyxey/rqDeZe1KlRAoxA+OTLVO/QZDk=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "terminaltexteffects" ];

  meta = {
    description = "Collection of visual effects that can be applied to terminal piped stdin text";
    homepage = "https://chrisbuilds.github.io/terminaltexteffects";
    changelog = "https://chrisbuilds.github.io/terminaltexteffects/changeblog/changeblog/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "tte";
  };
})
