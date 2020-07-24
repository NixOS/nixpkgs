{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "step-ca";
  version = "0.13.3";

  goPackagePath = "github.com/smallstep/certificates";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "certificates";
    rev = "v${version}";
    sha256 = "1i42j7v5a5qqqb9ng8irblfyzykhyws0394q3zac290ymjijxbnq";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A private certificate authority (X.509 & SSH) & ACME server for secure automated certificate management, so you can use TLS everywhere & SSO for SSH";
    homepage = "https://smallstep.com/certificates/";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
