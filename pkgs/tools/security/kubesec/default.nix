{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubesec";
  version = "2.11.3";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ntDkkw1mOb3oAs/UX9uazKv1+smVy2qtg6ZqCLEbRNQ=";
  };

  vendorSha256 = "sha256-1qDi8Ij+uweZggE9fbi50uCqlPzdGOwiO3WPuAxnils=";

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
