{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  colorlog,
  dataclasses-json,
  nltk,
  numpy,
  pandas,
  psutil,
  py3langid,
  pytestCheckHook,
  python-dateutil,
  standard-imghdr,
  standard-sndhdr,
  scipy,
  toml,
}:
let
  testNltkData = nltk.dataDir (d: [
    d.punkt
    d.punkt-tab
    d.stopwords
  ]);

  version = "0.0.25";
  tag = "v${version}";
in
buildPythonPackage {
  pname = "type-infer";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mindsdb";
    repo = "type_infer";
    inherit tag;
    hash = "sha256-WL/2WSy3e2Mg/jNS8afUEnCt10wpXho4uOPAkVdzHWA=";
  };

  patches = [
    # https://github.com/mindsdb/type_infer/pull/83
    (fetchpatch {
      url = "https://github.com/mindsdb/type_infer/commit/d09f88d5ddbe55125b1fff4506b03165d019d88b.patch";
      hash = "sha256-wNBzb+RxoZC8zn5gdOrtJeXJIIH3DTt1gTZfgN/WnQQ=";
    })
  ];

  pythonRelaxDeps = [
    "psutil"
    "py3langid"
    "numpy"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    colorlog
    dataclasses-json
    nltk
    numpy
    pandas
    psutil
    py3langid
    python-dateutil
    scipy
    standard-imghdr
    standard-sndhdr
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # test hangs
    "test_1_stack_overflow_survey"
  ];

  # Package import requires NLTK data to be downloaded
  # It is the only way to set NLTK_DATA environment variable,
  # so that it is available in pythonImportsCheck
  env.NLTK_DATA = testNltkData;
  pythonImportsCheck = [ "type_infer" ];

  meta = with lib; {
    changelog = "https://github.com/mindsdb/type_infer/releases/tag/${tag}";
    description = "Automated type inference for Machine Learning pipelines";
    homepage = "https://github.com/mindsdb/type_infer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
