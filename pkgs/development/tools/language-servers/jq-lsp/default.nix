{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jq-lsp";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "jq-lsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-a3ZqVWG7kjWQzL1efrKc4s4D14qD/+6JM26vaduxhWg=";
  };

  vendorHash = "sha256-bIe006I1ryvIJ4hC94Ux2YVdlmDIM4oZaK/qXafYYe0=";

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
