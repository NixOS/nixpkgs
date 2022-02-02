{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.7.10";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F1+goZURc0f1dWV/PGxSVtqHkuePACq4+UzfMTEVJ0M=";
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
