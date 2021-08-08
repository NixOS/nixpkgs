{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terracognita";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "cycloidio";
    repo = pname;
    rev = "v${version}";
    sha256 = "119rbjg3lsm73mdw6ymvslyj4y4ghj3a3dvxnvkrm55v9g0s03l9";
  };

  vendorSha256 = "1fvp53d694a4aj8l4hj7q2lvyadn9y9c52q4bzl6yrfjq6708y8d";

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
