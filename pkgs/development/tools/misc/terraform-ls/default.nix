{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0WbUJYNRBKixRFl+YM1uSEltQneB6FYPFHNVVhmdseA=";
  };
  vendorSha256 = "sha256-WYTn2QoI1Z3L4Wxjrq0YT++X9vMA1Wm3zgl08CYiU1Y=";

  # tests fail in sandbox mode because of trying to download stuff from releases.hashicorp.com
  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Terraform Language Server (official)";
    homepage = "https://github.com/hashicorp/terraform-ls";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mbaillie ];
  };
}
