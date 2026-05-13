{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  dill,
  jre_minimal,
  joblib,
  pandas,
  scikit-learn,

  # tests
  pytestCheckHook,
  statsmodels,
}:

let
  jre = jre_minimal.override {
    modules = [
      "java.base"
      "java.desktop"
      "java.instrument"
      "java.logging"
      "java.net.http"
      "java.sql"
      "java.xml"
    ];
  };
in
buildPythonPackage (finalAttrs: {
  pname = "sklearn2pmml";
  version = "0.130.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpmml";
    repo = "sklearn2pmml";
    tag = finalAttrs.version;
    hash = "sha256-u+fuOiJ0YTyxVZkKhBhxn0gUHbLRQ69WwSX2GwhYaHU=";
  };

  postPatch = ''
    substituteInPlace sklearn2pmml/__init__.py \
      --replace-fail 'result.extend(["java"])' 'result.extend(["${lib.getExe jre}"])'

    # Fix deprecated dash-separated key in setup.cfg
    substituteInPlace setup.cfg \
      --replace-fail "description-file" "description_file"
  '';

  build-system = [ setuptools ];

  dependencies = [
    dill
    joblib
    pandas
    scikit-learn
  ];

  nativeCheckInputs = [
    pytestCheckHook
    statsmodels
  ];

  enabledTestPaths = [
    # Only run the main test suite; subpackage tests require
    # sklearn-pandas which is not available in nixpkgs
    "sklearn2pmml/tests"
  ];

  pythonImportsCheck = [ "sklearn2pmml" ];

  meta = {
    description = "Python library for converting Scikit-Learn pipelines to PMML";
    homepage = "https://github.com/jpmml/sklearn2pmml";
    changelog = "https://github.com/jpmml/sklearn2pmml/blob/${finalAttrs.version}/NEWS.md";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # bundled JAR files
    ];
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
})
