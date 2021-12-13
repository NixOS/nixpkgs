{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.7.8";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QxfMfuqSxuyvzNC79sr4U0tdj2pSvGKQ28V3E523z+U=";
  };

  vendorSha256 = "sha256-Duu6lP87KKLC1eGIebycBSIPw7FN6BBxPexize9+jPE=";

  subPackages = [
    "cmd/stripe"
  ];

  meta = with lib; {
    homepage = "https://stripe.com/docs/stripe-cli";
    description = "A command-line tool for Stripe";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ RaghavSood ];
  };
}
