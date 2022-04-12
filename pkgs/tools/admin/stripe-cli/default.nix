{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TP366SozSNfxUGYXIOObfIul0BhQtIGQYZLwH/TPFs0=";
  };

  vendorSha256 = "sha256-1c+YtfRy1ey0z117YHHkrCnpb7g+DmM+LR1rjn1YwMQ=";

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
