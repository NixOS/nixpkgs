{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cookiecutter
, filelock
, huggingface-hub
, importlib-metadata
, regex
, requests
, numpy
, packaging
, tensorflow
, sagemaker
, ftfy
, protobuf
, scikit-learn
, pillow
, pyyaml
, torch
, tokenizers
, tqdm
}:

buildPythonPackage rec {
  pname = "transformers";
  version = "4.20.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3Kx7/3IJM428KXfOPRnPK4TYnAIXVOIMl33j8n5Cw60=";
  };

  propagatedBuildInputs = [
    filelock
    huggingface-hub
    numpy
    protobuf
    packaging
    pyyaml
    regex
    requests
    tokenizers
    tqdm
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  passthru.optional-dependencies = {
    ja = [
      # fugashi
      # ipadic
      # unidic_lite
      # unidic
    ];
    sklearn = [
      scikit-learn
    ];
    tf = [
      tensorflow
      # onnxconverter-common
      # tf2onnx
    ];
    torch = [
      torch
    ];
    tokenizers = [
      tokenizers
    ];
    modelcreation = [
      cookiecutter
    ];
    sagemaker = [
      sagemaker
    ];
    ftfy = [ ftfy ];
    onnx = [
      # onnxconverter-common
      # tf2onnx
    ];
    vision = [
      pillow
    ];
  };


  # Many tests require internet access.
  doCheck = false;

  pythonImportsCheck = [
    "transformers"
  ];

  meta = with lib; {
    homepage = "https://github.com/huggingface/transformers";
    description = "Natural Language Processing for TensorFlow 2.0 and PyTorch";
    changelog = "https://github.com/huggingface/transformers/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pashashocky ];
  };
}
