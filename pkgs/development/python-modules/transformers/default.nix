{ buildPythonPackage
, stdenv
, fetchFromGitHub
, boto3
, filelock
, regex
, requests
, numpy
, parameterized
, protobuf
, sacremoses
, sentencepiece
, timeout-decorator
, tokenizers
, tqdm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "transformers";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    sha256 = "1v09gryxsg57d2cjwagna1535m8mbxlazdbhsww210lxa818m5qj";
  };

  propagatedBuildInputs = [
    filelock
    numpy
    protobuf
    regex
    requests
    sacremoses
    sentencepiece
    tokenizers
    tqdm
  ];

  checkInputs = [
    parameterized
    pytestCheckHook
    timeout-decorator
  ];

  preCheck = ''
    export HOME="$TMPDIR"

    # This test requires the `datasets` module to download test
    # data. However, since we cannot download in the Nix sandbox
    # and `dataset` is an optional dependency for transformers
    # itself, we will just remove the tests files that import
    # `dataset`.
    rm tests/test_retrieval_rag.py
    rm tests/test_trainer.py
  '';

  # We have to run from the main directory for the tests. However,
  # letting pytest discover tests leads to errors.
  pytestFlagsArray = [ "tests" ];

  # Disable tests that require network access.
  disabledTests = [
    "BlenderbotSmallTokenizerTest"
    "Blenderbot3BTokenizerTests"
    "TokenizationTest"
    "TestTokenizationBart"
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
    "test_tokenizer_from_tokenizer_class"
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
