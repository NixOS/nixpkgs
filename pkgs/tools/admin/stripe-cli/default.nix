{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2wiry3bBrxrhyyPT/81VpAS34XBZgZsz8Wlq8Qeybgk=";
  };

  vendorSha256 = "sha256-Lgd1vGXlZw0s4dVC0TlGEYoGOLrJPc/bZ75Mzke4rrg=";

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
