{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r0szzw3xl9cn5vcqgn6sc4wbk2j17r1rhg14qgix835lzp9wpdv";
  };

  vendorSha256 = "05cyn9cgmijj6dl075slwm5qc6fj6m5sm414wqm50xz2fjs0400r";

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
