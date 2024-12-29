{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sshocker";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "sshocker";
    rev = "refs/tags/v${version}";
    hash = "sha256-IDbGRQSLQlT4lt2bextGYB4fJfbpLhPx3JF1eYDJ6gw=";
  };

  vendorHash = "sha256-kee5D80RjCVosts/Jd6WuvtiK/J5+79HsM5ITHs15xc=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/lima-vm/sshocker/pkg/version.Version=${version}"
  ];

  meta = with lib; {
    description = "Tool for SSH, reverse sshfs and port forwarder";
    mainProgram = "sshocker";
    homepage = "https://github.com/lima-vm/sshocker";
    changelog = "https://github.com/lima-vm/sshocker/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
