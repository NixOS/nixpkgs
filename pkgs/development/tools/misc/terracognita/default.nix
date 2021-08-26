{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terracognita";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "cycloidio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-n+aCNKGujvmXSFmLo2h1d29NFgdk/G+ehGwMHCJQoU8=";
  };

  vendorSha256 = "sha256-i6AkLAXGOXe3jmAKKQN6aX/DvovSS9CYFYO28bYIdUw=";

  doCheck = false;

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/cycloidio/terracognita/cmd.Version=${version}" ];

  meta = with lib; {
    description = "Reads from existing Cloud Providers (reverse Terraform) and generates your infrastructure as code on Terraform configuration";
    homepage = "https://github.com/cycloidio/terracognita";
    changelog = "https://github.com/cycloidio/terracognita/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
