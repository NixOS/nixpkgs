{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "fd";
  version = "8.6.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "sha256-RVGCSUYyWo2wKRIrnci+aWEAPW9jHhMfYkYJkCgd7f8=";
  };

  cargoSha256 = "sha256-PT95U1l+BVX7sby3GKktZMmbNNQoPYR8nL+H90EnqZY=";

  auditable = true; # TODO: remove when this is the default

  nativeBuildInputs = [ installShellFiles ];

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
  };
}
