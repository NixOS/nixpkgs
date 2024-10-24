{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jq-lsp";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "jq-lsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-ueSf32C4BznDKBQD0OIJKZhrwLq1xpn6WWEnsqoWkl8=";
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
