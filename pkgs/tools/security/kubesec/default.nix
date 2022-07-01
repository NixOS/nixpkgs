{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubesec";
  version = "2.11.4";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-z1v+xm0ZWs8F5KtltBSDx9W+xNqRsfvAgQUKgrZa+28=";
  };

  vendorSha256 = "sha256-t2GZaLa/Pc/TCjqTNGuLnOFSepExmE2xA8pc9HkUtcs=";

  # Tests wants to download the kubernetes schema for use with kubeval
  doCheck = false;

  meta = with lib; {
    description = "Security risk analysis tool for Kubernetes resources";
    homepage = "https://github.com/controlplaneio/kubesec";
    changelog = "https://github.com/controlplaneio/kubesec/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
