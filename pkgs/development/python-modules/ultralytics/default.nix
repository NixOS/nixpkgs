{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  scipy,
  matplotlib,
  opencv-python,
  pillow,
  pyyaml,
  requests,
  torch,
  torchvision,
  tqdm,
  psutil,
  py-cpuinfo,
  pandas,
  seaborn,
  ultralytics-thop,

  # tests
  pytestCheckHook,
  onnx,
  onnxruntime,
}:

buildPythonPackage rec {
  pname = "ultralytics";
  version = "8.3.86";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ultralytics";
    repo = "ultralytics";
    tag = "v${version}";
    hash = "sha256-9z6f/48jQVCR744ojNH+T22+JDg31+WEKWi48k5/GoY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=1.23.0,<=2.1.1" "numpy"
  '';

  build-system = [ setuptools ];

  dependencies = [
    scipy
    matplotlib
    opencv-python
    pillow
    pyyaml
    requests
    scipy
    torch
    torchvision
    tqdm
    psutil
    py-cpuinfo
    pandas
    seaborn
    ultralytics-thop
  ];

  pythonImportsCheck = [ "ultralytics" ];

  nativeCheckInputs = [
    pytestCheckHook
    onnx
    onnxruntime
  ];

  # rest of the tests require internet access
  pytestFlagsArray = [ "tests/test_python.py" ];

  disabledTests = [
    # also remove the individual tests that require internet
    "test_model_methods"
    "test_predict_txt"
    "test_predict_img"
    "test_predict_visualize"
    "test_predict_grey_and_4ch"
    "test_val"
    "test_train_scratch"
    "test_train_pretrained"
    "test_all_model_yamls"
    "test_workflow"
    "test_predict_callback_and_setup"
    "test_results"
    "test_labels_and_crops"
    "test_data_annotator"
    "test_model_embeddings"
    "test_yolov10"
    "test_utils_torchutils"
    "test_yolo_world"
  ];

  meta = {
    homepage = "https://github.com/ultralytics/ultralytics";
    changelog = "https://github.com/ultralytics/ultralytics/releases/tag/${src.tag}";
    description = "Train YOLO models for computer vision tasks";
    mainProgram = "yolo";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ osbm ];
  };
}
