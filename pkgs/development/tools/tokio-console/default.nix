{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "tokio-console";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "console";
    rev = "tokio-console-v${version}";
    sha256 = "sha256-yTNLKpBkzzN0X73CjN/UXRGjAGOnCCgJa6A6loA6baM=";
  };

  cargoSha256 = "sha256-K/auhqlL/K6RYE0lHyvSUqK1cOwJBBZD3QTUevZzLXQ=";

  nativeBuildInputs = [ protobuf ];

  # uses currently unstable tokio features
  RUSTFLAGS = "--cfg tokio_unstable";

  checkFlags = [
    # tests depend upon git repository at test execution time
    "--skip bootstrap"
    "--skip config::tests::args_example_changed"
    "--skip config::tests::toml_example_changed"
  ];

  meta = with lib; {
    description = "A debugger for asynchronous Rust code";
    homepage = "https://github.com/tokio-rs/console";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ max-niederman ];
  };
}
