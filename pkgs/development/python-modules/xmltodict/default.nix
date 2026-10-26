{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "xmltodict";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "martinblech";
    repo = "xmltodict";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G7hVtS6toUJC0YY1AXBOJSc3wnAZyWilLnT/5vvFRRw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xmltodict" ];

  meta = {
    description = "Makes working with XML feel like you are working with JSON";
    homepage = "https://github.com/martinblech/xmltodict";
    changelog = "https://github.com/martinblech/xmltodict/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
