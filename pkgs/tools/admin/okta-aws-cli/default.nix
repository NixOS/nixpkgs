{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "okta-aws-cli";
  version = "1.2.2";

  subPackages = [ "cmd/okta-aws-cli" ];

  src = fetchFromGitHub {
    owner  = "okta";
    repo   = "okta-aws-cli";
    rev    = "v${version}";
    sha256 = "sha256-GF+2xPoc9dztB7w6pOLwiZ6D9b4P1YEJrZxL33j4aew=";
  };

  vendorHash = "sha256-AJmQxMRj602yodzIdhZV+R22KxnEIbT9iSz/5G5T6r8=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A CLI for having Okta as the IdP for AWS CLI operations";
    homepage = "https://github.com/okta/okta-aws-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ daniyalsuri6 ];
  };
}
