{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "tokio-console";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "console";
    rev = "tokio-console-v${version}";
    sha256 = "089wabzhbdd3s23n3qandwqmfwg3l7rrv9sn12x8a0xczr9kh30m";
  };

  cargoSha256 = "sha256-tJErAv+7HLUDLG/UhbzrIY90o/ak9jjvVnI3nlQzQO4=";

  nativeBuildInputs = [ protobuf ];

  cargoPatches = [ ./cargo-lock.patch ];

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
