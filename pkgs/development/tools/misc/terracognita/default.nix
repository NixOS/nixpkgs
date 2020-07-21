{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terracognita";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "cycloidio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s6k78n94q13crdlgxb5c8qn708nbzn6nmhkil4s23f0qdskcah2";
  };

  vendorSha256 = "1dmv16v1c9sydbl1g69pgwvrhznd0a133giwrcbqi4cyg1fdb3sr";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/cycloidio/terracognita/cmd.Version=${version}" ];

  meta = with lib; {
    description = "Reads from existing Cloud Providers (reverse Terraform) and generates your infrastructure as code on Terraform configuration";
    homepage = "https://github.com/cycloidio/terracognita";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}