{ lib, fetchFromGitHub, buildGoModule, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
    sha256 = "sha256-8Pz1Xa8P0T+5P4qCoyRyRqPtAaSiZw4BV+rSZf4exC0=";
  };

  vendorHash = "sha256-NIJH5Ya+fZ+37y+Lim/WizNCOYk1lpPRf6u70IoiFZk=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = with lib; {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    mainProgram = "nextcloud-exporter";
  };
}
