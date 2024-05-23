{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "vault-medusa";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "jonasvinther";
    repo = "medusa";
    rev = "v${version}";
    sha256 = "sha256-4fYtWRWonZC9HSNGMqZZPH3xHi6wPk3vSF+htu34g6A=";
  };

  vendorHash = "sha256-GdQiPeU5SWZlqWkyk8gU9yVTUQxJlurhY3l1xZXKeJY=";

  meta = with lib; {
    description = "A cli tool for importing and exporting Hashicorp Vault secrets";
    mainProgram = "medusa";
    homepage = "https://github.com/jonasvinther/medusa";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
