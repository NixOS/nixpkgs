{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, rpm
, xz
}:

buildGoModule rec {
  pname = "clair";
<<<<<<< HEAD
  version = "4.7.1";
=======
  version = "4.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-+ABZafDc2nmHHnJGXj4iCSheuWoksPwDblmdIusUJuo=";
  };

  vendorHash = "sha256-ptgHU/PrLqRG4h3C5x+XUy4+38Yu6h4gTeziaPJ2iWE=";
=======
    hash = "sha256-Nd73GQJUYkFMyvMLAUgu/LQuDEW74s9+YKwqnftPoPM=";
  };

  vendorHash = "sha256-V9Y+dZv3RKiyzGJB1o4+M4QQeRpBkCtJOr2zyjTCKTY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    makeWrapper
  ];

  subPackages = [
    "cmd/clair"
    "cmd/clairctl"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/clair \
      --prefix PATH : "${lib.makeBinPath [ rpm xz ]}"
  '';

  meta = with lib; {
    description = "Vulnerability Static Analysis for Containers";
    homepage = "https://github.com/quay/clair";
    changelog = "https://github.com/quay/clair/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
