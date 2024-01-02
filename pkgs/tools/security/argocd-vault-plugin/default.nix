{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "argocd-vault-plugin";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "argoproj-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YH7yNRaKdYzasaxYSManuiImyxglmIwgLvDKjUg3MR8=";
  };

  vendorHash = "sha256-0PrGrcS8Gx0cVImGrlmXlycFgWCTLjg2ISi0OhYoPpw=";

  # integration tests require filesystem and network access for credentials
  doCheck = false;

  meta = with lib; {
    homepage = "https://argocd-vault-plugin.readthedocs.io";
    changelog = "https://github.com/argoproj-labs/argocd-vault-plugin/releases/tag/v${version}";
    description = "An Argo CD plugin to retrieve secrets from Secret Management tools and inject them into Kubernetes secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
