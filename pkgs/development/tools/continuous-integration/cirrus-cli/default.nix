{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:

buildGoModule rec {
  pname = "cirrus-cli";
  version = "0.113.1";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RAka5uYNsTq/zBT9sjdrZFY1CmJ5Vzdj1gfWvMERcPA=";
  };

  vendorHash = "sha256-NPtQM4nm8QiHY2wSd7VHx6T5LRb7EB39x+xFzHOUcNs=";

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
