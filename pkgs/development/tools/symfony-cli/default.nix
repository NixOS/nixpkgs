{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
<<<<<<< HEAD
  version = "5.5.8";
  vendorHash = "sha256-hOYVIynWsbsindNJRbXX4NkC3FW3RErORCSLlV1bCWc=";
=======
  version = "5.5.5";
  vendorHash = "sha256-hDr/ByBCjKE+B698IXzDFq1ovS6Nfs4O32aF7HKmrcY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-K2DttdK8g5NI+XlGwIA9HTPTLlMGgGc1K625FquIhi4=";
=======
    sha256 = "sha256-bieFHg3hO8bQuA3yvhQVpG8hVdvQ29RVG7wAPhE0lpQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/symfony-cli $out/bin/symfony
  '';

  # Tests requires network access
  checkPhase = ''
    $GOPATH/bin/symfony-cli
  '';

<<<<<<< HEAD
  meta = {
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = lib.licenses.agpl3Plus;
    mainProgram = "symfony";
    maintainers = with lib.maintainers; [ drupol ];
=======
  meta = with lib; {
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ drupol ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
