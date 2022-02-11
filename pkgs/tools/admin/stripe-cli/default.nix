{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.7.11";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-a2GoTdt6l6Yayaz1n1VdKxwrziNuFk/MO/6PvjqRxVM=";
  };

  vendorSha256 = "sha256-AsEem/KuA+jxioG96Ofn0te93fyZ9sebPkLPA+LAUkk=";

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
