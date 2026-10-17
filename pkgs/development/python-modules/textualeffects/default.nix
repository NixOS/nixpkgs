{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  terminaltexteffects,
}:

buildPythonPackage (finalAttrs: {
  pname = "textualeffects";
  version = "0.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-5C84ZdvcgVgxroFZycOdHdB4my3qK8b4wVxD4kd+XfE=";
  };

  build-system = [ hatchling ];

  dependencies = [ terminaltexteffects ];

  pythonImportsCheck = [ "textualeffects" ];

  # no tests implemented
  doCheck = false;

  meta = {
    description = "Visual effects for Textual, a TerminalTextEffects wrapper";
    homepage = "https://github.com/ggozad/textualeffects";
    changelog = "https://github.com/ggozad/textualeffects/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
  };
})
