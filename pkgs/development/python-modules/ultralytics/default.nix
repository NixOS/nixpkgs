{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  lap,
  matplotlib,
  opencv-python,
  pandas,
  pillow,
  polars,
  psutil,
  py-cpuinfo,
  pyyaml,
  requests,
  scipy,
  seaborn,
  torch,
  torchvision,
  tqdm,
  ultralytics-thop,

  # tests
  aiohttp,
  onnx,
  onnxruntime,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ultralytics";
  version = "8.4.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ultralytics";
    repo = "ultralytics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P6NNEWCpwSN2FU9Nc+XHwjx3xC2kmhbZ/71utEBBjuM=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "numpy"
  ];

  dependencies = [
    lap
    matplotlib
    opencv-python
    pandas
    pillow
    polars
    psutil
    py-cpuinfo
    pyyaml
    requests
    scipy
    scipy
    seaborn
    torch
    torchvision
    tqdm
    ultralytics-thop
  ];

  pythonImportsCheck = [ "ultralytics" ];

  nativeCheckInputs = [
    aiohttp
    onnx
    onnxruntime
    pytestCheckHook
  ];

  enabledTestPaths = [
    # rest of the tests require internet access
    "tests/test_python.py"
  ];

  disabledTests = [
    # also remove the individual tests that require internet
    "test_predict_gray_and_4ch"
    "test_all_model_yamls"
    "test_data_annotator"
    "test_labels_and_crops"
    "test_model_embeddings"
    "test_model_methods"
    "test_predict_callback_and_setup"
    "test_predict_grey_and_4ch"
    "test_predict_img"
    "test_predict_txt"
    "test_predict_visualize"
    "test_results"
    "test_train_pretrained"
    "test_train_scratch"
    "test_utils_torchutils"
    "test_val"
    "test_workflow"
    "test_yolo_world"
    "test_yolov10"
    "test_yoloe"
    "test_multichannel"
    "test_grayscale"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Fatal Python error: Aborted
    # onnxruntime/capi/_pybind_state.py", line 32 in <module>
    "test_utils_benchmarks"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Fatal Python error: Aborted
    # ultralytics/utils/checks.py", line 598 in check_imshow
    "test_utils_checks"

    # RuntimeError: required keyword attribute 'value' has the wrong type
    "test_utils_benchmarks"

    # RuntimeError: Dataset 'https://github.com/ultralytics/assets/releases/download/v0.0.0/coco8-ndjson.ndjson'
    # error <E2><9D><8C> [Errno 13] Permission denied:
    # '/nix/store/rnns5r21nibx26f2c2gxdk3h8l0jcg68-python3.12-ultralytics-8.3.221/datasets/coco8-ndjson/labels/train/000000000009.txt'
    "test_train_ndjson"
  ];

  meta = {
    homepage = "https://github.com/ultralytics/ultralytics";
    changelog = "https://github.com/ultralytics/ultralytics/releases/tag/${finalAttrs.src.tag}";
    description = "Train YOLO models for computer vision tasks";
    mainProgram = "yolo";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      osbm
      mana-byte
    ];
    badPlatforms = [
      # Tests crash with:
      # Fatal Python error: Segmentation fault for x86_64 Darwin in tests/python.py
      "x86_64-darwin"
    ];
  };
})
