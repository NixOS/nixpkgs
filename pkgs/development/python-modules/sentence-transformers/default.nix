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
  version = "5.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "sentence-transformers";
    tag = "v${version}";
    hash = "sha256-FNJ4mWBcgy3J8ZJtHt+uBgNmvMnqphj+sLMmBvgdB1k=";
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
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "sentence_transformers" ];

  disabledTests = [
    # Tests require network access
    "test_LabelAccuracyEvaluator"
    "test_ParaphraseMiningEvaluator"
    "test_TripletEvaluator"
    "test_cmnrl_same_grad"
    "test_default_weights_when_none"
    "test_dense_load_and_save_in_other_precisions"
    "test_dimension_exceeds_model_dimension_raises_error"
    "test_dimensions_sorted_descending"
    "test_empty_matryoshka_dims_raises_error"
    "test_forward"
    "test_initialization_with_embedding_dim"
    "test_initialization_with_embedding_weights"
    "test_loading_model2vec"
    "test_mine_hard_negatives_with_prompt"
    "test_model_card_base"
    "test_model_card_reuse"
    "test_model_dimension_not_in_dims_warns"
    "test_mse_loss_matryoshka"
    "test_nanobeir_evaluator"
    "test_negative_dimension_raises_error"
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
    "test_valid_initialization_no_warnings"
    "test_valid_initialization_with_weights"
    "test_weights_length_mismatch_raises_error"
    "test_zero_dimension_raises_error"

    # Assertion error: Sparse operations take too long
    # (namely, load-sensitive test)
    "test_performance_with_large_vectors"

    # NameError: name 'ParallelismConfig' is not defined
    "test_hf_argument_parser"
    "test_hf_argument_parser_incorrect_string_arguments"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin) [
    # These sparse tests also time out, on x86_64-darwin.
    "sim_sparse"
  ];

  disabledTestPaths = [
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
    "tests/util/test_hard_negatives.py"
  ];

  # Sentence-transformer needs a writable hf_home cache
  postInstall = ''
    export HF_HOME=$(mktemp -d)
  '';

  meta = {
    description = "Multilingual Sentence & Image Embeddings with BERT";
    homepage = "https://github.com/huggingface/sentence-transformers";
    changelog = "https://github.com/huggingface/sentence-transformers/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
