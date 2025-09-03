{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # runtime dependencies
  layoutparser,
  python-multipart,
  huggingface-hub,
  opencv-python,
  onnxruntime,
  transformers,
  detectron2,
  paddleocr,
  # check inputs
  pytestCheckHook,
  coverage,
  click,
  httpx,
  mypy,
  pytest-cov-stub,
  pdf2image,
}:

buildPythonPackage rec {
  pname = "unstructured-inference";
  version = "1.0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Unstructured-IO";
    repo = "unstructured-inference";
    tag = version;
    hash = "sha256-3eyavjGUc3qbKuTorAiefisz4TjiG5v/88lsXYmcFmo=";
  };

  propagatedBuildInputs = [
    layoutparser
    python-multipart
    huggingface-hub
    opencv-python
    onnxruntime
    transformers
    # detectron2 # fails to build
    # paddleocr # 3.12 not yet supported
    # yolox
  ]
  ++ layoutparser.optional-dependencies.layoutmodels
  ++ layoutparser.optional-dependencies.tesseract;

  nativeCheckInputs = [
    pytestCheckHook
    coverage
    click
    httpx
    mypy
    pytest-cov-stub
    pdf2image
    huggingface-hub
  ];

  # This dependency needs to be updated properly
  doCheck = false;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # not sure why this fails
    "test_get_path_oob_move_deeply_nested"
    "test_get_path_oob_move_nested[False]"
    # requires yolox
    "test_yolox"
  ];

  disabledTestPaths = [
    # network access
    "test_unstructured_inference/inference/test_layout.py"
    "test_unstructured_inference/models/test_chippermodel.py"
    "test_unstructured_inference/models/test_detectron2onnx.py"
    # unclear failure
    "test_unstructured_inference/models/test_donut.py"
    "test_unstructured_inference/models/test_model.py"
    "test_unstructured_inference/models/test_tables.py"
  ];

  pythonImportsCheck = [ "unstructured_inference" ];

  meta = with lib; {
    description = "Hosted model inference code for layout parsing models";
    homepage = "https://github.com/Unstructured-IO/unstructured-inference";
    changelog = "https://github.com/Unstructured-IO/unstructured-inference/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
