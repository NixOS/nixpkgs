{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.1.0";
  vendorSha256 = "sha256-vnevuJoDiAx/Z6uKO/SX3UV3j/jsXXNlnui6Nzm+tBA=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    sha256 = "sha256-leoR/zW6MHuZH/9xJlO0kYpr1UWpA1WWjXP7+4JkPBg=";
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
