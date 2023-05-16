{ lib, fetchFromGitHub, buildGoModule, nixosTests, fetchpatch }:

buildGoModule rec {
  pname = "prometheus-nextcloud-exporter";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "xperimental";
    repo = "nextcloud-exporter";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-8Pz1Xa8P0T+5P4qCoyRyRqPtAaSiZw4BV+rSZf4exC0=";
  };

  vendorHash = "sha256-NIJH5Ya+fZ+37y+Lim/WizNCOYk1lpPRf6u70IoiFZk=";
=======
    sha256 = "sha256-/EwQSxYDaf7B8A48aelf1yYbM7Vw6ntoz1VuYM2HDEc=";
  };

  vendorSha256 = "sha256-b05N5TXsRHD8h3q+ckxaVizq+A7VqkDWOSb0LOMGCHM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nextcloud; };

  meta = with lib; {
    description = "Prometheus exporter for Nextcloud servers";
    homepage = "https://github.com/xperimental/nextcloud-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    mainProgram = "nextcloud-exporter";
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
