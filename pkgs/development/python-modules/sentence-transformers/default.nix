{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  accelerate,
  datasets,
  huggingface-hub,
  optimum,
  pillow,
  scikit-learn,
  scipy,
  torch,
  tqdm,
  transformers,
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "sentence-transformers";
  version = "4.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "UKPLab";
    repo = "sentence-transformers";
    tag = "v${version}";
    hash = "sha256-sBTepBXSFyDX1zUu/iAj6PamCWhV8fjRbaFN7fBmOao=";
  };

  build-system = [ setuptools ];

  dependencies = [
    huggingface-hub
    pillow
    scikit-learn
    scipy
    torch
    tqdm
    transformers
    typing-extensions
  ];

  optional-dependencies = {
    train = [
      accelerate
      datasets
    ];
    onnx = [ optimum ] ++ optimum.optional-dependencies.onnxruntime;
    # onnx-gpu = [ optimum ] ++ optimum.optional-dependencies.onnxruntime-gpu;
    # openvino = [ optimum-intel ] ++ optimum-intel.optional-dependencies.openvino;
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "sentence_transformers" ];

  disabledTests = [
    # Tests require network access
    "test_LabelAccuracyEvaluator"
    "test_ParaphraseMiningEvaluator"
    "test_TripletEvaluator"
    "test_cmnrl_same_grad"
    "test_forward"
    "test_initialization_with_embedding_dim"
    "test_initialization_with_embedding_weights"
    "test_loading_model2vec"
    "test_model_card_base"
    "test_model_card_reuse"
    "test_nanobeir_evaluator"
    "test_paraphrase_mining"
    "test_pretrained_model"
    "test_save_and_load"
    "test_simple_encode"
    "test_tokenize"
    "test_trainer"
    "test_trainer_invalid_column_names"
    "test_trainer_multi_dataset_errors"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/cross_encoder/test_cross_encoder.py"
    "tests/cross_encoder/test_train_stsb.py"
    "tests/evaluation/test_information_retrieval_evaluator.py"
    "tests/test_compute_embeddings.py"
    "tests/test_model_card_data.py"
    "tests/test_multi_process.py"
    "tests/test_pretrained_stsb.py"
    "tests/test_sentence_transformer.py"
    "tests/test_train_stsb.py"
  ];

  # Sentence-transformer needs a writable hf_home cache
  postInstall = ''
    export HF_HOME=$(mktemp -d)
  '';

  meta = {
    description = "Multilingual Sentence & Image Embeddings with BERT";
    homepage = "https://github.com/UKPLab/sentence-transformers";
    changelog = "https://github.com/UKPLab/sentence-transformers/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
