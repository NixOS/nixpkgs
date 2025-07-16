{
  lib,
  attrs,
  buildPythonPackage,
  commoncode,
  fetchPypi,
  packaging,
  pytestCheckHook,
  pythonOlder,
  saneyaml,
  semantic-version,
  semver,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "univers";
  version = "31.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BqP5seUOhkZQBdi7ClaUDasr7h8A7YRidgISpQHVR1E=";
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

  meta = with lib; {
    description = "Library for parsing version ranges and expressions";
    homepage = "https://github.com/aboutcode-org/univers";
    changelog = "https://github.com/aboutcode-org/univers/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [
      asl20
      bsd3
      mit
    ];
    maintainers = with maintainers; [
      armijnhemel
      sbruder
    ];
  };
}
