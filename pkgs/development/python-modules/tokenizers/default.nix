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
  fetchTestData =
    name: hash:
    fetchurl {
      url = "https://huggingface.co/datasets/hf-internal-testing/tokenizers-test-data/resolve/main/${name}";
      inherit hash;
    };

  # The test suite downloads those files from the `hf-internal-testing/tokenizers-test-data`
  # dataset. See https://github.com/huggingface/tokenizers/blob/main/bindings/python/tests/utils.py
  test-data = linkFarm "tokenizers-test-data" (
    lib.mapAttrs fetchTestData {
      "albert-base-v1-tokenizer.json" = "sha256-biqj1cpMaEG8NqUCgXnLTWPBKZMfoY/OOP2zjOxNKsM=";
      "bert-base-uncased-vocab.txt" = "sha256-B+ztN1zsFE0nyQAkHz4zlHjeyVj5L928VR8pXJkgOKM=";
      "bert-wiki.json" = "sha256-i533xC8J5CDMNxBjo+p6avIM8UOcui8RmGAmK0GmfBc=";
      "big.txt" = "sha256-+gZsfUDw8gGsQUTmUqpiQw5YprOAXscGUPZ42lgE6Hs=";
      "openai-gpt-merges.txt" = "sha256-Dqm1GuaVBzzYceA1j3AWMR1nGn/zlj42fVI2Ui8pRyU=";
      "openai-gpt-vocab.json" = "sha256-/fSbGefeI2hSCR2gm4Sno81eew55kWN2z0X2uBJ7gHg=";
      "roberta-base-merges.txt" = "sha256-HOFmR3PFDz4MyIQmGak+3EYkUltyixiKngvjO3cmrcU=";
      "roberta-base-vocab.json" = "sha256-nn9jwtFdZmtS4h0lDS5RO4fJtxPPpph6gu2J5eblBlU=";
      "small.txt" = "sha256-sE7qWm92PyCeBF5PYJDASlT7wkAOdmLtIegrGh2sQVc=";
      "tokenizer-wiki.json" = "sha256-ipY9d5DR5nxoO6kj7rItueZ9AO5wq9+Nzr6GuEIfIBI=";
    }
  );
in
buildPythonPackage (finalAttrs: {
  pname = "tokenizers";
  version = "0.23.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "tokenizers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-liHx1YRFZC/PUNiv1MJyb9oAw7/xHbaRbFsn1n8gtuI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-AVmmOqyH1iX5agDjB58SpzHuk56aV2d1lvopVcR6u4s=";
  };

  sourceRoot = "${finalAttrs.src.name}/bindings/python";

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

  postPatch =
    # Read the test data from the local `tests/data` directory populated in `postUnpack`
    # rather than downloading it from the Hugging Face Hub
    ''
      substituteInPlace tests/utils.py \
        --replace-fail \
          'return hf_hub_download(repo_id=HF_TEST_REPO, filename=filename, repo_type="dataset")' \
          'return os.path.join(DATA_PATH, filename)'
    '';

  pythonImportsCheck = [ "tokenizers" ];

  disabledTests = [
    # Downloads a dataset using the `datasets` module
    "TestTrainFromIterators"

    # Require downloading models from the Hugging Face Hub
    "TestAsyncTokenizer"
    "test_decode_skip_special_tokens"
    "test_decode_stream_fallback"
    "test_encode_special_tokens"
    "test_from_pretrained"
    "test_from_pretrained_revision"
    "test_splitting"
  ];

  disabledTestPaths = [
    # fixture 'model' not found
    "benches/test_tiktoken.py"
  ];

  meta = {
    description = "Fast State-of-the-Art Tokenizers optimized for Research and Production";
    homepage = "https://github.com/huggingface/tokenizers";
    changelog = "https://github.com/huggingface/tokenizers/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.unix;
  };
})
