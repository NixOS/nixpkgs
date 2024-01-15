{ lib
, stdenv
, linkFarm
, buildPythonPackage
, cargo
, datasets
, fetchFromGitHub
, fetchurl
, libiconv
, numpy
, openssl
, pkg-config
, pytestCheckHook
, pythonOlder
, requests
, rustPlatform
, rustc
, Security
, setuptools-rust
}:

let
  # See https://github.com/huggingface/tokenizers/blob/main/bindings/python/tests/utils.py for details
  # about URLs and file names
  test-data = linkFarm "tokenizers-test-data" {
    "roberta-base-vocab.json" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/roberta-base-vocab.json";
      sha256 = "0m86wpkfb2gdh9x9i9ng2fvwk1rva4p0s98xw996nrjxs7166zwy";
    };
    "roberta-base-merges.txt" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/roberta-base-merges.txt";
      sha256 = "1idd4rvkpqqbks51i2vjbd928inw7slij9l4r063w3y5fd3ndq8w";
    };
    "albert-base-v1-tokenizer.json" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/albert-base-v1-tokenizer.json";
      sha256 = "1hra9pn8rczx7378z88zjclw2qsdrdwq20m56sy42s2crbas6akf";
    };
    "bert-base-uncased-vocab.txt" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/bert-base-uncased-vocab.txt";
      sha256 = "18rq42cmqa8zanydsbzrb34xwy4l6cz1y900r4kls57cbhvyvv07";
    };
    "big.txt" = fetchurl {
      url = "https://norvig.com/big.txt";
      sha256 = "0yz80icdly7na03cfpl0nfk5h3j3cam55rj486n03wph81ynq1ps";
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
      sha256 = "0y40gc9bixj5rxv674br1rxmxkd3ly29p80x1596h8yywwcrpx7x";
    };
    "openai-gpt-merges.txt" = fetchurl {
      url = "https://s3.amazonaws.com/models.huggingface.co/bert/openai-gpt-merges.txt";
      sha256 = "09a754pm4djjglv3x5pkgwd6f79i2rq8ydg0f7c3q1wmwqdbba8f";
    };
  };
in
buildPythonPackage rec {
  pname = "tokenizers";
  version = "0.15.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+yfX12eKtgZV1OQvPOlMVTONbpFuigHcl4SjoCIZkSk=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  sourceRoot = "${src.name}/bindings/python";

  nativeBuildInputs = [
    pkg-config
    setuptools-rust
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    datasets
    pytestCheckHook
    requests
  ];

  postUnpack = ''
    # Add data files for tests, otherwise tests attempt network access
    mkdir $sourceRoot/tests/data
    ln -s ${test-data}/* $sourceRoot/tests/data/
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "tokenizers"
  ];

  disabledTests = [
    # Downloads data using the datasets module
    "TestTrainFromIterators"
    # Those tests require more data
    "test_from_pretrained"
    "test_from_pretrained_revision"
    "test_continuing_prefix_trainer_mistmatch"
  ];

  meta = with lib; {
    description = "Fast State-of-the-Art Tokenizers optimized for Research and Production";
    homepage = "https://github.com/huggingface/tokenizers";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
