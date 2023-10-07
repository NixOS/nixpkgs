{ lib
, buildPythonPackage
, fetchFromGitHub
, huggingface-hub
, nltk
, numpy
, scikit-learn
, scipy
, sentencepiece
, tokenizers
, torch
, torchvision
, tqdm
, transformers
}:

buildPythonPackage rec {
  pname = "sentence-transformers";
  version = "2.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "UKPLab";
    repo = "sentence-transformers";
    rev = "v${version}";
    hash = "sha256-hEYpDAL0lliaS1j+c5vaZ0q1hw802jfTUurx/FvgY9w=";
  };

  propagatedBuildInputs = [
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

  pythonImportsCheck = [ "sentence_transformers" ];

  doCheck = false; # tests fail at build_ext

  meta = with lib; {
    description = "Multilingual Sentence & Image Embeddings with BERT";
    homepage = "https://github.com/UKPLab/sentence-transformers";
    changelog = "https://github.com/UKPLab/sentence-transformers/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
