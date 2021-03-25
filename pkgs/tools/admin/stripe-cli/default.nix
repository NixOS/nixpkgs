{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.5.10";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cedreUdLjUONA8iVlQ/OfOJtM8EgCI8zaKDCbruUIVo=";
  };

  vendorSha256 = "sha256-hYvW5xAbnxOEapFc70wOF9ybbDv7hLGljKqHI+1Itaw=";

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
