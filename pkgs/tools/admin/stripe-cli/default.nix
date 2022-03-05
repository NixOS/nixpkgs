{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.7.13";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XYhOBEpHVAJ/PHovMylme56le33IUM5C9HEZAm/gG3I=";
  };

  vendorSha256 = "sha256-OP39ZuWBz/lutuYGbYLVEtjIirXq89QTdltq2v0NWRE=";

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
