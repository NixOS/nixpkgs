{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kubesec";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "controlplaneio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vT+SiSt9QoOkGbnPdKkzE8yehNJMa/3jYC+4h4QeNmw=";
  };

  vendorSha256 = "sha256-zfQu1EdwvR+LGmsbE8RA4pcOGgsukG1TMTCgPyNoVsc=";

  # Tests wants to download additional files
  doCheck = false;

  meta = with lib; {
    description = "Security risk analysis tool for Kubernetes resources";
    homepage = "https://github.com/controlplaneio/kubesec";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
