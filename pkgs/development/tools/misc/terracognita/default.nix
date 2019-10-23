{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terracognita";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "cycloidio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ljh9dyn919k5f0yaca5an2vczj8cd5cb6qb4i5bdgmlh3wijiag";
  };

  modSha256 = "1ssz6rhdqma79x75qsxpa9is5zw1nlc0rv1h23dfsk8vla3p84ml";

  meta = with lib; {
    description = "Reads from existing Cloud Providers (reverse Terraform) and generates your infrastructure as code on Terraform configuration";
    homepage = "https://github.com/cycloidio/terracognita";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
