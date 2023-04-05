{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:

buildGoModule rec {
  pname = "cirrus-cli";
  version = "0.96.0";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gX1c10oDGt3n+W6/s4k5JX7V6SuYL8lNRewAmJf8gqQ=";
  };

  vendorHash = "sha256-Qirv06KhisEmQ+v9Z5jgkJFV4McnH+5r2xbU3wRc0DI=";

  ldflags = [
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Version=v${version}"
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Commit=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd cirrus \
      --bash <($out/bin/cirrus completion bash) \
      --zsh <($out/bin/cirrus completion zsh) \
      --fish <($out/bin/cirrus completion fish)
  '';

  # tests fail on read-only filesystem
  doCheck = false;

  meta = with lib; {
    description = "CLI for executing Cirrus tasks locally and in any CI";
    homepage = "https://github.com/cirruslabs/cirrus-cli";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ techknowlogick ];
    mainProgram = "cirrus";
  };
}
