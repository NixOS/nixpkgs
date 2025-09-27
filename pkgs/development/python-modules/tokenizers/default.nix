{
  lib,
  linkFarm,
  fetchurl,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  cargo,
  pkg-config,
  rustPlatform,
  rustc,
  setuptools-rust,

  # buildInputs
  openssl,

  # dependencies
  huggingface-hub,

  # tests
  datasets,
  numpy,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  tiktoken,
  writableTmpDirAsHomeHook,
}:

let
  # See https://github.com/huggingface/tokenizers/blob/main/bindings/python/tests/utils.py for details
  # about URLs and file names
  test-data = linkFarm "tokenizers-test-data" {
    "roberta-base-vocab.json" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/roberta-base-vocab.json";
      hash = "sha256-nn9jwtFdZmtS4h0lDS5RO4fJtxPPpph6gu2J5eblBlU=";
    };
    "roberta-base-merges.txt" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/roberta-base-merges.txt";
      hash = "sha256-HOFmR3PFDz4MyIQmGak+3EYkUltyixiKngvjO3cmrcU=";
    };
    "albert-base-v1-tokenizer.json" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/albert-base-v1-tokenizer.json";
      hash = "sha256-biqj1cpMaEG8NqUCgXnLTWPBKZMfoY/OOP2zjOxNKsM=";
    };
    "bert-base-uncased-vocab.txt" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/bert-base-uncased-vocab.txt";
      hash = "sha256-B+ztN1zsFE0nyQAkHz4zlHjeyVj5L928VR8pXJkgOKM=";
    };
    "tokenizer-llama3.json" = fetchurl {
      url = "https://huggingface.co/Narsil/llama-tokenizer/resolve/main/tokenizer.json";
      hash = "sha256-eePlImNfMXEwCRO7QhRkqH3mIiGCoFcLmyzLoqlksrQ=";
    };
    "big.txt" = fetchurl {
      url = "https://norvig.com/big.txt";
      hash = "sha256-+gZsfUDw8gGsQUTmUqpiQw5YprOAXscGUPZ42lgE6Hs=";
    };
    "bert-wiki.json" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/anthony/doc-pipeline/tokenizer.json";
      hash = "sha256-i533xC8J5CDMNxBjo+p6avIM8UOcui8RmGAmK0GmfBc=";
    };
    "tokenizer-wiki.json" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/anthony/doc-quicktour/tokenizer.json";
      hash = "sha256-ipY9d5DR5nxoO6kj7rItueZ9AO5wq9+Nzr6GuEIfIBI=";
    };
    "openai-gpt-vocab.json" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/openai-gpt-vocab.json";
      hash = "sha256-/fSbGefeI2hSCR2gm4Sno81eew55kWN2z0X2uBJ7gHg=";
    };
    "openai-gpt-merges.txt" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/openai-gpt-merges.txt";
      hash = "sha256-Dqm1GuaVBzzYceA1j3AWMR1nGn/zlj42fVI2Ui8pRyU=";
    };
  };
in
buildPythonPackage rec {
  pname = "tokenizers";
  version = "0.22.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "tokenizers";
    tag = "v${version}";
    hash = "sha256-1ijP16Fw/dRgNXXX9qEymXNaamZmlNFqbfZee82Qz6c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-CKbnFtwsEtJ11Wnn8JFpHd7lnUzQMTwJ1DmmB44qciM=";
  };

  sourceRoot = "${src.name}/bindings/python";

  nativeBuildInputs = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
    setuptools-rust
  ];

  buildInputs = [
    openssl
  ];

  dependencies = [
    huggingface-hub
  ];

  nativeCheckInputs = [
    datasets
    numpy
    pytest-asyncio
    pytestCheckHook
    requests
    tiktoken
    writableTmpDirAsHomeHook
  ];

  postUnpack =
    # Add data files for tests, otherwise tests attempt network access
    ''
      mkdir $sourceRoot/tests/data
      ln -s ${test-data}/* $sourceRoot/tests/data/
    '';

  pythonImportsCheck = [ "tokenizers" ];

  disabledTests = [
    # Downloads data using the datasets module
    "test_encode_special_tokens"
    "test_splitting"
    "TestTrainFromIterators"

    # Require downloading from huggingface
    # huggingface_hub.errors.LocalEntryNotFoundError
    "test_async_methods_existence"
    "test_basic_encoding"
    "test_concurrency"
    "test_decode"
    "test_decode_skip_special_tokens"
    "test_decode_stream_fallback"
    "test_encode"
    "test_error_handling"
    "test_large_batch"
    "test_numpy_inputs"
    "test_performance_comparison"
    "test_various_input_formats"
    "test_with_special_tokens"
    "test_with_truncation_padding"

    # Those tests require more data
    "test_from_pretrained"
    "test_from_pretrained_revision"
    "test_continuing_prefix_trainer_mistmatch"
  ];

  disabledTestPaths = [
    # fixture 'model' not found
    "benches/test_tiktoken.py"
  ];

  meta = {
    description = "Fast State-of-the-Art Tokenizers optimized for Research and Production";
    homepage = "https://github.com/huggingface/tokenizers";
    changelog = "https://github.com/huggingface/tokenizers/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.unix;
  };
}
