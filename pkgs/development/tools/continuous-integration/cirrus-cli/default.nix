{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:

buildGoModule rec {
  pname = "cirrus-cli";
  version = "0.105.1";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F0T/4KUz0iU/THE8iRSdKe0Wo3HWQMYOd5vmbO61SzA=";
  };

  vendorHash = "sha256-+cxh3/TQqm6n7hUYhW2B3pdfdtzRuepZmLNSGVPA3H0=";

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
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ techknowlogick ];
    mainProgram = "cirrus";
  };
}
