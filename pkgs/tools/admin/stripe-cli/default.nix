{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5Dvmlzhu7xqJAcAdyjPJ/iMooK7N+Qv8J93uEySYb/s=";
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
  };
}
