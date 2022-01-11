{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, buildPythonPackage
, rustPlatform
, setuptools-rust
, libiconv
, numpy
, datasets
, pytestCheckHook
, requests
}:

let
  robertaVocab = fetchurl {
    url = "https://s3.amazonaws.com/models.huggingface.co/bert/roberta-base-vocab.json";
    sha256 = "0m86wpkfb2gdh9x9i9ng2fvwk1rva4p0s98xw996nrjxs7166zwy";
  };
  robertaMerges = fetchurl {
    url = "https://s3.amazonaws.com/models.huggingface.co/bert/roberta-base-merges.txt";
    sha256 = "1idd4rvkpqqbks51i2vjbd928inw7slij9l4r063w3y5fd3ndq8w";
  };
  albertVocab = fetchurl {
    url = "https://s3.amazonaws.com/models.huggingface.co/bert/albert-base-v1-tokenizer.json";
    sha256 = "1hra9pn8rczx7378z88zjclw2qsdrdwq20m56sy42s2crbas6akf";
  };
  bertVocab = fetchurl {
    url = "https://s3.amazonaws.com/models.huggingface.co/bert/bert-base-uncased-vocab.txt";
    sha256 = "18rq42cmqa8zanydsbzrb34xwy4l6cz1y900r4kls57cbhvyvv07";
  };
  norvigBig = fetchurl {
    url = "https://norvig.com/big.txt";
    sha256 = "0yz80icdly7na03cfpl0nfk5h3j3cam55rj486n03wph81ynq1ps";
  };
  docPipelineTokenizer = fetchurl {
    url = "https://s3.amazonaws.com/models.huggingface.co/bert/anthony/doc-pipeline/tokenizer.json";
    hash = "sha256-i533xC8J5CDMNxBjo+p6avIM8UOcui8RmGAmK0GmfBc=";
  };
  docQuicktourTokenizer = fetchurl {
    url = "https://s3.amazonaws.com/models.huggingface.co/bert/anthony/doc-quicktour/tokenizer.json";
    hash = "sha256-ipY9d5DR5nxoO6kj7rItueZ9AO5wq9+Nzr6GuEIfIBI=";
  };
  openaiVocab = fetchurl {
    url = "https://s3.amazonaws.com/models.huggingface.co/bert/openai-gpt-vocab.json";
    sha256 = "0y40gc9bixj5rxv674br1rxmxkd3ly29p80x1596h8yywwcrpx7x";
  };
  openaiMerges = fetchurl {
    url = "https://s3.amazonaws.com/models.huggingface.co/bert/openai-gpt-merges.txt";
    sha256 = "09a754pm4djjglv3x5pkgwd6f79i2rq8ydg0f7c3q1wmwqdbba8f";
  };
in buildPythonPackage rec {
  pname = "tokenizers";
  version = "unstable-2021-08-13";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "e7dd6436dd4a4ffd9e8a4f110ca68e6a38677cb6";
    sha256 = "1p7w9a43a9h6ys5nsa4g89l65dj11037p7a1lqkj4x1yc9kv2y1r";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src sourceRoot;
    name = "${pname}-${version}";
    sha256 = "1yb4jsx6mp9jgd1g3mli6vr6mri2afnwqlmxq1rpvn34z6b3iw9q";
  };

  sourceRoot = "source/bindings/python";

  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    datasets
    pytestCheckHook
    requests
  ];

  postUnpack = ''
    # Add data files for tests, otherwise tests attempt network access.
    mkdir $sourceRoot/tests/data
    ( cd $sourceRoot/tests/data
      ln -s ${robertaVocab} roberta-base-vocab.json
      ln -s ${robertaMerges} roberta-base-merges.txt
      ln -s ${albertVocab} albert-base-v1-tokenizer.json
      ln -s ${bertVocab} bert-base-uncased-vocab.txt
      ln -s ${docPipelineTokenizer} bert-wiki.json
      ln -s ${docQuicktourTokenizer} tokenizer-wiki.json
      ln -s ${norvigBig} big.txt
      ln -s ${openaiVocab} openai-gpt-vocab.json
      ln -s ${openaiMerges} openai-gpt-merges.txt )
  '';

  postPatch = ''
    echo 'import multiprocessing; multiprocessing.set_start_method("fork")' >> tests/__init__.py
  '';

  preCheck = ''
    HOME=$TMPDIR
  '';

  disabledTests = [
    # Downloads data using the datasets module.
    "TestTrainFromIterators"
  ];

  meta = with lib; {
    homepage = "https://github.com/huggingface/tokenizers";
    description = "Fast State-of-the-Art Tokenizers optimized for Research and Production";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
