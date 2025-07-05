{
  lib,
  stdenv,
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
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "UKPLab";
    repo = "sentence-transformers";
    tag = "v${version}";
    hash = "sha256-7HdeNyB3hMJEwHenN2hUEGG2MdQ++nF3nyAYJv7jhyA=";
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
    "test_mine_hard_negatives_with_prompt"
    "test_model_card_base"
    "test_model_card_reuse"
    "test_nanobeir_evaluator"
    "test_paraphrase_mining"
    "test_pretrained_model"
    "test_router_as_middle_module"
    "test_router_backwards_compatibility"
    "test_router_encode"
    "test_router_load_with_config"
    "test_router_save_load"
    "test_router_save_load_with_custom_default_route"
    "test_router_save_load_with_multiple_modules_per_route"
    "test_router_save_load_without_default_route"
    "test_router_with_trainer"
    "test_router_with_trainer_without_router_mapping"
    "test_save_and_load"
    "test_simple_encode"
    "test_tokenize"
    "test_train_stsb"
    "test_trainer"
    "test_trainer_invalid_column_names"
    "test_trainer_multi_dataset_errors"
  ];

  disabledTestPaths =
    [
      # Tests require network access
      "tests/cross_encoder/test_cross_encoder.py"
      "tests/cross_encoder/test_train_stsb.py"
      "tests/evaluation/test_information_retrieval_evaluator.py"
      "tests/sparse_encoder/models/test_csr.py"
      "tests/sparse_encoder/models/test_sparse_static_embedding.py"
      "tests/sparse_encoder/test_opensearch_models.py"
      "tests/sparse_encoder/test_pretrained.py"
      "tests/sparse_encoder/test_sparse_encoder.py"
      "tests/test_compute_embeddings.py"
      "tests/test_model_card_data.py"
      "tests/test_multi_process.py"
      "tests/test_pretrained_stsb.py"
      "tests/test_sentence_transformer.py"
      "tests/test_train_stsb.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Segfault
      "tests/test_sparse_tensor.py"
    ];

  # Sentence-transformer needs a writable hf_home cache
  postInstall = ''
    export HF_HOME=$(mktemp -d)
  '';

  meta = {
    description = "Multilingual Sentence & Image Embeddings with BERT";
    homepage = "https://github.com/UKPLab/sentence-transformers";
    changelog = "https://github.com/UKPLab/sentence-transformers/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
