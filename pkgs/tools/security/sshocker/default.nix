{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sshocker";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "sshocker";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z1Dg+AeyfFmUDc3jV8/tOcUrxuyInfwubzo0cLpfFl8=";
  };

  vendorHash = "sha256-ceQzYByJNXr02IDBKhYuqnKfaTbnX5T03p2US4HRu6I=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/lima-vm/sshocker/pkg/version.Version=${version}"
  ];

  meta = with lib; {
    description = "Tool for SSH, reverse sshfs and port forwarder";
    homepage = "https://github.com/lima-vm/sshocker";
    changelog = "https://github.com/lima-vm/sshocker/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
