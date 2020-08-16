{ stdenv
, rustPlatform
, fetchFromGitHub
, fetchurl
, maturin
, pipInstallHook
, pytest
, python
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
  bertVocab = fetchurl {
    url = "https://s3.amazonaws.com/models.huggingface.co/bert/bert-base-uncased-vocab.txt";
    sha256 = "18rq42cmqa8zanydsbzrb34xwy4l6cz1y900r4kls57cbhvyvv07";
  };
  openaiVocab = fetchurl {
    url = "https://s3.amazonaws.com/models.huggingface.co/bert/openai-gpt-vocab.json";
    sha256 = "0y40gc9bixj5rxv674br1rxmxkd3ly29p80x1596h8yywwcrpx7x";
  };
  openaiMerges = fetchurl {
    url = "https://s3.amazonaws.com/models.huggingface.co/bert/openai-gpt-merges.txt";
    sha256 = "09a754pm4djjglv3x5pkgwd6f79i2rq8ydg0f7c3q1wmwqdbba8f";
  };
in rustPlatform.buildRustPackage rec {
  pname = "tokenizers";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "python-v${version}";
    sha256 = "0sxdwx05hr87j2z32rk4rgwn6a26w9r7m5fgj6ah1sgagiiyxbjw";
  };

  # Update parking_lot to be compatible with recent Rust versions, that
  # replace asm! by llvm_asm!:
  #
  # https://github.com/Amanieu/parking_lot/pull/223
  #
  # Remove once upstream updates this dependency.
  cargoPatches = [ ./update-parking-lot.diff ];

  cargoSha256 = "0cdkxmj8z2wdspn6r62lqlpvd0sj1z0cmb1zpqaajxvr0b2kjlj8";

  sourceRoot = "source/bindings/python";

  nativeBuildInputs = [
    maturin
    pipInstallHook
  ];

  propagatedBuildInputs = [
    python
  ];

  # tokenizers uses pyo3, which requires Rust nightly.
  RUSTC_BOOTSTRAP = 1;

  doCheck = false;
  doInstallCheck = true;

  postUnpack = ''
    # Add data files for tests, otherwise tests attempt network access.
    mkdir $sourceRoot/tests/data
    ( cd $sourceRoot/tests/data
      ln -s ${robertaVocab} roberta-base-vocab.json
      ln -s ${robertaMerges} roberta-base-merges.txt
      ln -s ${bertVocab} bert-base-uncased-vocab.txt
      ln -s ${openaiVocab} openai-gpt-vocab.json
      ln -s ${openaiMerges} openai-gpt-merges.txt )
  '';

  postPatch = ''
    # pyo3's build check verifies that Rust is a nightly
    # version. Disable this check.
    substituteInPlace $NIX_BUILD_TOP/$cargoDepsCopy/pyo3/build.rs \
      --replace "check_rustc_version()?;" ""

    # Patching the vendored dependency invalidates the file
    # checksums, so remove them. This should be safe, since
    # this is just a copy of the vendored dependencies and
    # the integrity of the vendored dependencies is validated
    # by cargoSha256.
    sed -r -i 's|"files":\{[^}]+\}|"files":{}|' \
      $NIX_BUILD_TOP/$cargoDepsCopy/pyo3/.cargo-checksum.json

    # Maturin uses the crate name as the wheel name.
    substituteInPlace Cargo.toml \
      --replace "tokenizers-python" "tokenizers"
  '';

  buildPhase = ''
    maturin build --release --manylinux off
  '';

  installPhase = ''
    # Put the wheels where the pip install hook can find them.
    install -Dm644 -t dist target/wheels/*.whl
    pipInstallPhase
  '';

  installCheckInputs = [
    pytest
    requests
  ];

  installCheckPhase = ''
    # Append paths, or the binding's tokenizer module will be
    # used, since the test directories have __init__.py
    pytest --import-mode=append
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/huggingface/tokenizers";
    description = "Fast State-of-the-Art Tokenizers optimized for Research and Production";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ danieldk ];
  };
}
