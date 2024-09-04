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
  version = "30.12.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NbsoYfTk5SWyUQZnOdm+ZCXK7wD+DV/updRHqHoU49c=";
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
    homepage = "https://github.com/nexB/univers";
    changelog = "https://github.com/nexB/univers/blob/v${version}/CHANGELOG.rst";
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
