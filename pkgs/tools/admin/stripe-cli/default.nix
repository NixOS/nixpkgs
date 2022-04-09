{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-R1w+dVBIPbmBOhtVWKfB4tS+Jp1/tahRk6rifPM53HA=";
  };

  vendorSha256 = "sha256-KgoSJcVUtE4ryJLtQXNCdl51sgO94vyb682OdL5CYw8=";

  subPackages = [
    "cmd/stripe"
  ];

  meta = with lib; {
    homepage = "https://stripe.com/docs/stripe-cli";
    description = "A command-line tool for Stripe";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ RaghavSood ];
    mainProgram = "stripe";
  };
}
