{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "argocd-vault-plugin";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "argoproj-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9gM4CD3MbZX3ZCZ3XCAkdOkE381jgGvg/swto4B74g8=";
  };

  vendorHash = "sha256-r9Pcm95gU0QTiREdiQiyJMOKZb5Lt2bIJywLerzgbdg=";

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
