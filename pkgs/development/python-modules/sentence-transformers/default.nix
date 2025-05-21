{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  huggingface-hub,
  nltk,
  numpy,
  scikit-learn,
  scipy,
  sentencepiece,
  tokenizers,
  torch,
  tqdm,
  transformers,

  # tests
  accelerate,
  datasets,
  pytestCheckHook,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "sentence-transformers";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "UKPLab";
    repo = "sentence-transformers";
    rev = "refs/tags/v${version}";
    hash = "sha256-Kp0B3+1zK45KypCaxH02U/JdzTBGwFAoxtmzek94QNI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    huggingface-hub
    nltk
    numpy
    scikit-learn
    scipy
    sentencepiece
    tokenizers
    torch
    tqdm
    transformers
  ];

  nativeCheckInputs = [
    accelerate
    datasets
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "sentence_transformers" ];

  disabledTests = [
    # Tests require network access
    "test_cmnrl_same_grad"
    "test_LabelAccuracyEvaluator"
    "test_model_card_reuse"
    "test_paraphrase_mining"
    "test_ParaphraseMiningEvaluator"
    "test_simple_encode"
    "test_trainer"
    "test_trainer_invalid_column_names"
    "test_trainer_multi_dataset_errors"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/evaluation/test_information_retrieval_evaluator.py"
    "tests/test_compute_embeddings.py"
    "tests/test_cross_encoder.py"
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
    changelog = "https://github.com/UKPLab/sentence-transformers/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
    # Segmentation fault at import
    broken = stdenv.hostPlatform.system == "x86_64-darwin";
  };
}
