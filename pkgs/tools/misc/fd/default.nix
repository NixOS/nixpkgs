{ lib, rustPlatform, fetchFromGitHub, installShellFiles, rust-jemalloc-sys, testers, fd }:

rustPlatform.buildRustPackage rec {
  pname = "fd";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    hash = "sha256-xcrvAWbSvUUtbFXyENy3eQimxt5aXzFrHnL6VptyydA=";
  };

  cargoHash = "sha256-z4PV8k6avaLwo58yJq47WEUJGw3JCW1GZGviBaPTs+8=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ rust-jemalloc-sys ];

  # skip flaky test
  checkFlags = [
    "--skip=test_owner_current_group"
  ];

  postInstall = ''
    installManPage doc/fd.1

    installShellCompletion --cmd fd \
      --bash <($out/bin/fd --gen-completions bash) \
      --fish <($out/bin/fd --gen-completions fish)
    installShellCompletion --zsh contrib/completion/_fd
  '';

  passthru.tests.version = testers.testVersion {
    package = fd;
  };

  meta = with lib; {
    description = "A simple, fast and user-friendly alternative to find";
    longDescription = ''
      `fd` is a simple, fast and user-friendly alternative to `find`.

      While it does not seek to mirror all of `find`'s powerful functionality,
      it provides sensible (opinionated) defaults for 80% of the use cases.
    '';
    homepage = "https://github.com/sharkdp/fd";
    changelog = "https://github.com/sharkdp/fd/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir figsoda globin ma27 zowoq ];
    mainProgram = "fd";
  };
}
