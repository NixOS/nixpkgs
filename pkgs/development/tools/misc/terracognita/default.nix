{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terracognita";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "cycloidio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ib0p361sxh2qzxccg32pcml4by4mk45abhljwmljwybs34wh5rh";
  };

  vendorSha256 = "0q772i49nyxzs51jrh45n14ljh7qj5wygkn2x32pxi6ykw6la4x8";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/cycloidio/terracognita/cmd.Version=${version}" ];

  meta = with lib; {
    description = "Reads from existing Cloud Providers (reverse Terraform) and generates your infrastructure as code on Terraform configuration";
    homepage = "https://github.com/cycloidio/terracognita";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}