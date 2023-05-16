{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "tokio-console";
<<<<<<< HEAD
  version = "0.1.9";
=======
  version = "0.1.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "console";
    rev = "tokio-console-v${version}";
<<<<<<< HEAD
    hash = "sha256-zISgEhUmAfHErq4AelbnSwtKjtxYH//pbLUAlPKxQYk=";
  };

  cargoHash = "sha256-qK8U6BZN7sdBP8CbzsDeewsGulNA/KFVS9vscBxysRg=";

  nativeBuildInputs = [ protobuf ];

  cargoPatches = [ ./cargo-lock.patch ];

=======
    sha256 = "sha256-yTNLKpBkzzN0X73CjN/UXRGjAGOnCCgJa6A6loA6baM=";
  };

  cargoSha256 = "sha256-K/auhqlL/K6RYE0lHyvSUqK1cOwJBBZD3QTUevZzLXQ=";

  nativeBuildInputs = [ protobuf ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mainProgram = "tokio-console";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ max-niederman ];
  };
}
