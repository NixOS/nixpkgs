{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubesec";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W9c3L8lYjF1W0kwSODhMldlqX1h+2mZIRtElZ20skn4=";
  };

  vendorSha256 = "sha256-zfQu1EdwvR+LGmsbE8RA4pcOGgsukG1TMTCgPyNoVsc=";

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
