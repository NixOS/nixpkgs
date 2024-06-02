{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jq-lsp";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "jq-lsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-c7uK8WPM/h2PLVLFGeN66SztvzjBCgJje7L14+oErVU=";
  };

  vendorHash = "sha256-8sZGnoP7l09ZzLJqq8TUCquTOPF0qiwZcFhojUnnEIY=";

  # based on https://github.com/wader/jq-lsp/blob/master/.goreleaser.yml
  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
    "-X main.builtBy=Nix"
  ];

  meta = with lib; {
    description = "jq language server";
    homepage = "https://github.com/wader/jq-lsp";
    license = licenses.mit;
    maintainers = with maintainers; [ sysedwinistrator ];
    mainProgram = "jq-lsp";
  };
}
