{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  huggingface-hub,
  nltk,
  numpy,
  pytestCheckHook,
  pythonOlder,
  scikit-learn,
  scipy,
  sentencepiece,
  setuptools,
  tokenizers,
  torch,
  torchvision,
  tqdm,
  transformers,
}:

buildPythonPackage rec {
  pname = "sentence-transformers";
  version = "2.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "UKPLab";
    repo = "sentence-transformers";
    rev = "refs/tags/v${version}";
    hash = "sha256-xER+WHprW83KWJ0bom+lTn0HNU7PgGROnp/QLG1uUcw=";
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
    torchvision
    tqdm
    transformers
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sentence_transformers" ];

  disabledTests = [
    # Tests require network access
    "test_simple_encode"
    "test_paraphrase_mining"
    "test_cmnrl_same_grad"
    "test_LabelAccuracyEvaluator"
    "test_ParaphraseMiningEvaluator"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_pretrained_stsb.py"
    "tests/test_sentence_transformer.py"
    "tests/test_compute_embeddings.py"
    "tests/test_multi_process.py"
    "tests/test_cross_encoder.py"
    "tests/test_train_stsb.py"
  ];

  meta = with lib; {
    description = "Multilingual Sentence & Image Embeddings with BERT";
    homepage = "https://github.com/UKPLab/sentence-transformers";
    changelog = "https://github.com/UKPLab/sentence-transformers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
