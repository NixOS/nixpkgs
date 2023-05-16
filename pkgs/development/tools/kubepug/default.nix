{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubepug";
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rikatz";
    repo = "kubepug";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-HjnkGEzTobtILqML5xcjpYVtg6a5PqMKYyaGTYrqEDo=";
  };

  vendorHash = "sha256-w2WwJa8qaXmgFwZJo2r2TowcTehgQY0nGY4u1UROaxM=";

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=${version}"
=======
    sha256 = "sha256-ySGNEs9PwkpjcLaCZ9M6ewE0/PRdwDksJMJ2GZUUrng=";
  };

  vendorSha256 = "sha256-faco4/6ldZiD2pkvjFgWDHbpCcNA4dGXxVhuO3PK77k=";

  ldflags = [
    "-s" "-w" "-X=github.com/rikatz/kubepug/version.Version=${src.rev}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  patches = [
    ./skip-external-network-tests.patch
  ];

  meta = with lib; {
    description = "Checks a Kubernetes cluster for objects using deprecated API versions";
    homepage = "https://github.com/rikatz/kubepug";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch ];
  };
}
