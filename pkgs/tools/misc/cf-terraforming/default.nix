{ buildGoModule, fetchFromGitHub, lib, cf-terraforming, testers }:

buildGoModule rec {
  pname = "cf-terraforming";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cf-terraforming";
    rev = "v${version}";
    sha256 = "sha256-wqpVqf4E5Zz8oKjl7XNjAH05wA++MOL9EnHL/YwsSYw=";
  };

  vendorSha256 = "sha256-tmq55wCQ10WkP+Cp3Ak6mttwL1wxqIAvpn6tsluhI34=";
  ldflags = [ "-X github.com/cloudflare/cf-terraforming/internal/app/cf-terraforming/cmd.versionString=${version}" ];

  # The test suite insists on downloading a binary release of Terraform from
  # Hashicorp at runtime, which isn't going to work in a nix build
  doCheck = false;

  passthru.tests = testers.testVersion {
    package = cf-terraforming;
    command = "cf-terraforming version";
  };

  meta = with lib; {
    description = "A command line utility to facilitate terraforming your existing Cloudflare resources";
    homepage = "https://github.com/cloudflare/cf-terraforming/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ benley ];
  };
}
