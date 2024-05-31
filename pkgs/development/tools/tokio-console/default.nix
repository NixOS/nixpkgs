{ lib
, fetchFromGitHub
, installShellFiles
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "tokio-console";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "console";
    rev = "tokio-console-v${version}";
    hash = "sha256-sjfdxOeaNANYJuJMjZ/tCGc2mWM+98d8yPHAVSl4cF4=";
  };

  cargoHash = "sha256-86KQpRpYSCQs6SUeG0HV26b58x/QUyovoL+5fg8JCOI=";

  nativeBuildInputs = [
    installShellFiles
    protobuf
  ];

  # uses currently unstable tokio features
  RUSTFLAGS = "--cfg tokio_unstable";

  checkFlags = [
    # tests depend upon git repository at test execution time
    "--skip bootstrap"
    "--skip config::tests::args_example_changed"
    "--skip config::tests::toml_example_changed"
  ];

  postInstall = ''
    installShellCompletion --cmd tokio-console \
      --bash <($out/bin/tokio-console --log-dir $(mktemp -d) gen-completion bash) \
      --fish <($out/bin/tokio-console --log-dir $(mktemp -d) gen-completion fish) \
      --zsh <($out/bin/tokio-console --log-dir $(mktemp -d) gen-completion zsh)
  '';

  meta = with lib; {
    description = "A debugger for asynchronous Rust code";
    homepage = "https://github.com/tokio-rs/console";
    mainProgram = "tokio-console";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ max-niederman ];
  };
}
