{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terracognita";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "cycloidio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RX2L9EwxfZ+utptTDR3+W9ACVPALF/hiE40SJTmZuLs=";
  };

  vendorSha256 = "sha256-sN9GTcG5cZxvMaLqNjY2jfLkf8a3lugM2aV3bBdT5Ww=";

  doCheck = false;

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/cycloidio/terracognita/cmd.Version=${version}" ];

  meta = with lib; {
    description = "Reads from existing Cloud Providers (reverse Terraform) and generates your infrastructure as code on Terraform configuration";
    homepage = "https://github.com/cycloidio/terracognita";
    changelog = "https://github.com/cycloidio/terracognita/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
