{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "tokio-console";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "console";
    rev = "tokio-console-v${version}";
    hash = "sha256-zISgEhUmAfHErq4AelbnSwtKjtxYH//pbLUAlPKxQYk=";
  };

  cargoHash = "sha256-qK8U6BZN7sdBP8CbzsDeewsGulNA/KFVS9vscBxysRg=";

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
    mainProgram = "tokio-console";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ max-niederman ];
  };
}
