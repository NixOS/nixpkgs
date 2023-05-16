{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "smokeping_prober";
<<<<<<< HEAD
  version = "0.7.1";
=======
  version = "0.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = let
    setVars = rec {
      Version = version;
      Revision = "722200c4adbd6d1e5d847dfbbd9dec07aa4ca38d";
      Branch = Revision;
      BuildUser = "nix";
    };
    varFlags = lib.concatStringsSep " " (lib.mapAttrsToList (name: value: "-X github.com/prometheus/common/version.${name}=${value}") setVars);
  in [
    "${varFlags}" "-s" "-w"
  ];

  src = fetchFromGitHub {
    owner = "SuperQ";
    repo = "smokeping_prober";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-kpg4oUDv1C5NQuxfFNLmRIMkc8hbMkjiKL16HkYrUyU=";
  };
  vendorHash = "sha256-TgieqjE23gwyKLuKSqc5pkxRpou8lg+yVnVoINZDkGU=";
=======
    sha256 = "sha256-tph9TZwMWKlJC/YweO9BU3+QRIugqc3ob5rqXThyR1c=";
  };
  vendorHash = "sha256-emabuOm5tuPNZWmPHJWUWzFVjuLrY7biv8V/3ru73aU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) smokeping; };

  meta = with lib; {
    description = "Prometheus exporter for sending continual ICMP/UDP pings";
    homepage = "https://github.com/SuperQ/smokeping_prober";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
