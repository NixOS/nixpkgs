{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "vault-medusa";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "jonasvinther";
    repo = "medusa";
    rev = "v${version}";
    sha256 = "sha256-VL22p723LDHpn+WhKoPm3u1uSTMofJpy3tZNlgcWQSk=";
  };

  vendorHash = "sha256-pptAtzw9vRguQJK73kjfM/wnTJDekXBWV3Yeb8p8LOY=";

  meta = with lib; {
    description = "A cli tool for importing and exporting Hashicorp Vault secrets";
    homepage = "https://github.com/jonasvinther/medusa";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
