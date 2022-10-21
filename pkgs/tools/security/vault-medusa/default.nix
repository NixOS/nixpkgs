{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "vault-medusa";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "jonasvinther";
    repo = "medusa";
    rev = "v${version}";
    sha256 = "sha256-W5OkLOtRH1l/h3liV7ANyS3jqu0IGM5ZnZGAk/Yaz6I=";
  };

  vendorSha256 = "sha256-mlZHA5XGtOg4yd1iepWvxPWx0VaIY3XotlW6CEm7i1k=";

  meta = with lib; {
    description = "A cli tool for importing and exporting Hashicorp Vault secrets";
    homepage = "https://github.com/jonasvinther/medusa";
    license = licenses.mit;
    maintainers = with maintainers; [ "bpaulin" ];
  };
}
