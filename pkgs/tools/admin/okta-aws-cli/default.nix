{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "okta-aws-cli";
  version = "2.0.1";

  subPackages = [ "cmd/okta-aws-cli" ];

  src = fetchFromGitHub {
    owner  = "okta";
    repo   = "okta-aws-cli";
    rev    = "v${version}";
    sha256 = "sha256-A49TpwvF7zQFCqffLeb1FOxbRwe4yhKSGs7YKNfpNSY=";
  };

  vendorHash = "sha256-SjABVO6tHYRc/1pYjOqfZP+NfnK1/WnAcY5NQ4hMssE=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A CLI for having Okta as the IdP for AWS CLI operations";
    homepage = "https://github.com/okta/okta-aws-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ daniyalsuri6 ];
  };
}
