{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  dill,
  jre,
  joblib,
  pandas,
  scikit-learn,

  # tests
  pytestCheckHook,
  statsmodels,
}:

buildPythonPackage rec {
  pname = "sklearn2pmml";
  version = "0.128.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpmml";
    repo = "sklearn2pmml";
    tag = version;
    hash = "sha256-iyCbDtJ/Tg26JJzivD9dQ5x9ev2ShAIc3lbu2KuV0IE=";
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

  pytestFlagsArray = [
    # Only run the main test suite; subpackage tests require
    # sklearn-pandas which is not available in nixpkgs
    "sklearn2pmml/tests"
  ];

  pythonImportsCheck = [ "sklearn2pmml" ];

  meta = {
    description = "Python library for converting Scikit-Learn pipelines to PMML";
    homepage = "https://github.com/jpmml/sklearn2pmml";
    changelog = "https://github.com/jpmml/sklearn2pmml/blob/${version}/NEWS.md";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # bundled JAR files
    ];
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
}
