{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.29.2";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hf86r5Q9fvk+vJsOjm6tqj6hT1eZpf8gtOmHA6wKwr0=";
  };

  vendorHash = "sha256-6+uQAEp+fRlRrwfJR0eDMXs0mEQwzWadLxCrXrDREhs=";

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
