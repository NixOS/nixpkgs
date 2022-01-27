{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.2.2";
  vendorSha256 = "sha256-/ct1DNSCB1KzajyHWe6guF5iYm5AAEbPunn7xYLw25I=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    sha256 = "sha256-qTt9FxphGi8o5hc3IaQGuIN+6t3KE/9xH9dv7i+C4ec=";
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
