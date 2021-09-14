{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CO+2BpMIUSaOhdia75zDGR4RZQSaxY05Z6TOKxBlKIw=";
  };

  vendorSha256 = "sha256-LOSHoEP0YRjfHav3MXSYPPrrjX6/ItxeVMOihRx0DTQ=";

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
