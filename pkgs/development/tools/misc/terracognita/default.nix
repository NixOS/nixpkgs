{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terracognita";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "cycloidio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9t3W/mHXXl8Sw/2iQ5D3U66LiO+/mQ56K+ihJCO4au4=";
  };

  vendorSha256 = "sha256-JkgkBxeUUQBb+VQzhovH5MnVwdxplKMVCGs4CX/fZlY=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/cycloidio/terracognita/cmd.Version=${version}" ];

  meta = with lib; {
    description = "Reads from existing Cloud Providers (reverse Terraform) and generates your infrastructure as code on Terraform configuration";
    homepage = "https://github.com/cycloidio/terracognita";
    changelog = "https://github.com/cycloidio/terracognita/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
