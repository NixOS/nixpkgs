{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "stripe-cli";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = pname;
    rev = "v${version}";
    sha256 = "0anrn7dkxgbzilh45gyqrp2930bkg3g3diarb50qp0rlim302sgy";
  };

  vendorSha256 = "05cyn9cgmijj6dl075slwm5qc6fj6m5sm414wqm50xz2fjs0400r";

  subPackages = [
    "cmd/stripe"
  ];

  meta = with stdenv.lib; {
    homepage = "https://stripe.com/docs/stripe-cli";
    description = "A command-line tool for Stripe";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ RaghavSood ];
  };
}
