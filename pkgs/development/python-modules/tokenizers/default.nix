{
  lib,
  stdenv,
  linkFarm,
  fetchurl,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # nativeBuildInputs
  pkg-config,
  setuptools-rust,
  rustPlatform,
  cargo,
  rustc,

  # buildInputs
  openssl,
  libiconv,
  Security,

  # dependencies
  huggingface-hub,
  numpy,

  # tests
  datasets,
  pytestCheckHook,
  requests,
  tiktoken,
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
    "big.txt" = fetchurl {
      url = "https://norvig.com/big.txt";
      sha256 = "sha256-+gZsfUDw8gGsQUTmUqpiQw5YprOAXscGUPZ42lgE6Hs=";
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
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "tokenizers";
    rev = "refs/tags/v${version}";
    hash = "sha256-uuSHsdyx77YQjf1aiz7EJ/X+6RaOgfmjGqHSlMaCWDI=";
  };

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  sourceRoot = "${src.name}/bindings/python";
  maturinBuildFlags = [ "--interpreter ${python.executable}" ];

  nativeBuildInputs = [
    pkg-config
    setuptools-rust
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      Security
    ];

  dependencies = [
    huggingface-hub
    numpy
  ];

  nativeCheckInputs = [
    datasets
    pytestCheckHook
    requests
    tiktoken
  ];

  postUnpack = ''
    # Add data files for tests, otherwise tests attempt network access
    mkdir $sourceRoot/tests/data
    ln -s ${test-data}/* $sourceRoot/tests/data/
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [ "tokenizers" ];

  disabledTests = [
    # Downloads data using the datasets module
    "test_encode_special_tokens"
    "test_splitting"
    "TestTrainFromIterators"

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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.unix;
  };
}
