{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  argocd-vault-plugin,
}:

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

  ldflags = [
    "-X=github.com/argoproj-labs/argocd-vault-plugin/version.Version=v${version}"
    "-X=github.com/argoproj-labs/argocd-vault-plugin/version.BuildDate=1970-01-01T00:00:00Z"
    "-X=github.com/argoproj-labs/argocd-vault-plugin/version.CommitSHA=unknown"
  ];

  # integration tests require filesystem and network access for credentials
  doCheck = false;

  doInstallCheck = true;

  passthru.tests.version = testers.testVersion {
    package = argocd-vault-plugin;
    command = "argocd-vault-plugin version";
    version = "argocd-vault-plugin v${version} (unknown) BuildDate: 1970-01-01T00:00:00Z";
  };

  meta = with lib; {
    homepage = "https://argocd-vault-plugin.readthedocs.io";
    changelog = "https://github.com/argoproj-labs/argocd-vault-plugin/releases/tag/v${version}";
    description = "An Argo CD plugin to retrieve secrets from Secret Management tools and inject them into Kubernetes secrets";
    mainProgram = "argocd-vault-plugin";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
