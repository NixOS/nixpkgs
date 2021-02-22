{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.5.9";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fR4MFEytYZA4zt4WFGnEp9YDCtX6peQoI+NynqyReT8=";
  };

  vendorSha256 = "sha256-GQACtHTid1Aq5iSQqks10hmGS+VUlwNoM1LG+liynhU=";

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
