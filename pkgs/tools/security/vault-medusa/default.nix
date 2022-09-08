{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "vault-medusa";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "jonasvinther";
    repo = "medusa";
    rev = "v${version}";
    sha256 = "sha256-KAKHuUv6nFVi3ucXkXGs9yfy2WFBnIDaDiNLKXsEOlI=";
  };

  vendorSha256 = "sha256-DCq+Dke33trkntrXz49I1mDxsJodVbtZEbg1UF6Tmwk=";

  meta = with lib; {
    description = "A cli tool for importing and exporting Hashicorp Vault secrets";
    homepage = "https://github.com/jonasvinther/medusa";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
