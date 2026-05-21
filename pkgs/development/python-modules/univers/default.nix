{
  lib,
  attrs,
  buildPythonPackage,
  commoncode,
  fetchPypi,
  packaging,
  pytestCheckHook,
  saneyaml,
  semantic-version,
  semver,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "univers";
  version = "32.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+uGHJF9yvuFYHymwsLbpBwSbLqE24+Ur+Njtv+8Q5/A=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    attrs
    packaging
    semantic-version
    semver
  ];

  nativeCheckInputs = [
    commoncode
    pytestCheckHook
    saneyaml
  ];

  dontConfigure = true; # ./configure tries to setup virtualenv and downloads dependencies

  pythonImportsCheck = [ "univers" ];

  disabledTests = [
    # No value for us
    "test_codestyle"
    # AssertionError starting with 30.10.0
    "test_enhanced_semantic_version"
    "test_semver_version"
  ];

  meta = {
    description = "Library for parsing version ranges and expressions";
    homepage = "https://github.com/aboutcode-org/univers";
    changelog = "https://github.com/aboutcode-org/univers/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = with lib.licenses; [
      asl20
      bsd3
      mit
    ];
    maintainers = with lib.maintainers; [
      armijnhemel
    ];
  };
})
