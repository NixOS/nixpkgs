{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Hlh2nfqQD+HMoJ2n1vfffn5ieEKSMtXpdoM0ydFQqrc=";
  };

  vendorSha256 = "sha256-DTNwgerJ7qZxH4imdrST7TaR20oevDluEDgAlubg5hw=";

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
