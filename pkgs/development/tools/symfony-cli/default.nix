{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.4.5";
  vendorSha256 = "sha256-ss3AtHigm1U3KhVhulIAquNf0WG7y4BSQcxs4pwnHVY=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    sha256 = "sha256-xYNq5hnkk6OIsnDHhN/vh1LNuP7isTNgtTY2WUwC8x4=";
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
