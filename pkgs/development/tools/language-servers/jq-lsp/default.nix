{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "jq-lsp";
  version = "unstable-2023-10-27";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "jq-lsp";
    rev = "b4707e7776a4eb3093b1a7533ebd41368240095a";
    hash = "sha256-AU4xGweeFx+kSsrqkTtSjl+N77cITF/qvAVZGUZY5SE=";
  };

  vendorHash = "sha256-ppQ81uERHBgOr/bm/CoDSWcK+IqHwvcL6RFi0DgoLuw=";

  meta = with lib; {
    description = "jq language server";
    homepage = "https://github.com/wader/jq-lsp";
    license = licenses.mit;
    maintainers = with maintainers; [ sysedwinistrator ];
    mainProgram = "jq-lsp";
  };
}
