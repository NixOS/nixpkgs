{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sshocker";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "sshocker";
    rev = "refs/tags/v${version}";
    hash = "sha256-u/H9X0YbjVFK8IMUmL6OdarP/ojqXjZAHI+k61Ja++w=";
  };

  vendorHash = "sha256-WcPKMF8KNx7zlsdTnFf8vnW/uZZL1F4JWqMK7+qmyCk=";

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
