{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.2.1";
  vendorSha256 = "sha256-vnevuJoDiAx/Z6uKO/SX3UV3j/jsXXNlnui6Nzm+tBA=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    sha256 = "sha256-51TkiOf3QkwuLv3l+aj5r5tgpDD/VglqeAjliCm5E5M=";
  };

  # Tests requires network access
  doCheck = false;

  meta = with lib; {
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ drupol ];
  };
}
