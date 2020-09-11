{ buildPythonPackage
, stdenv
, fetchFromGitHub
, boto3
, filelock
, regex
, requests
, numpy
, sacremoses
, sentencepiece
, timeout-decorator
, tokenizers
, tqdm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "transformers";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wg36qrcljmpsyhjaxpqw3s1r6276yg8cq0bjrf52l4zlc5k4xzk";
  };

  propagatedBuildInputs = [
    boto3
    filelock
    numpy
    regex
    requests
    sacremoses
    sentencepiece
    tokenizers
    tqdm
  ];

  checkInputs = [
    pytestCheckHook
    timeout-decorator
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "tokenizers == 0.8.1.rc2" "tokenizers>=0.8"
  '';

  preCheck = ''
    export HOME="$TMPDIR"
    cd tests

    # This test requires the nlp module, which we haven't
    # packaged yet. However, nlp is optional for transformers
    # itself
    rm test_trainer.py
  '';

  # Disable tests that require network access.
  disabledTests = [
    "PegasusTokenizationTest"
    "T5TokenizationTest"
    "test_all_tokenizers"
    "test_batch_encoding_is_fast"
    "test_batch_encoding_pickle"
    "test_config_from_model_shortcut"
    "test_config_model_type_from_model_identifier"
    "test_from_pretrained_use_fast_toggle"
    "test_hf_api"
    "test_outputs_can_be_shorter"
    "test_outputs_not_longer_than_maxlen"
    "test_padding_accepts_tensors"
    "test_pretokenized_tokenizers"
    "test_tokenizer_equivalence_en_de"
    "test_tokenizer_from_model_type"
    "test_tokenizer_from_model_type"
    "test_tokenizer_from_pretrained"
    "test_tokenizer_identifier_with_correct_config"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/huggingface/transformers";
    description = "State-of-the-art Natural Language Processing for TensorFlow 2.0 and PyTorch";
    changelog = "https://github.com/huggingface/transformers/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ danieldk pashashocky ];
  };
}
