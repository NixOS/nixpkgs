{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mtail";
<<<<<<< HEAD
  version = "3.0.0-rc52";
=======
  version = "3.0.0-rc46";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "google";
    repo = "mtail";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-F3UNvt7OicZJVcUgn5dQb7KjH0k3QOYOYDLrVpI5D64=";
  };

  vendorHash = "sha256-KD75KHXrXXm5FMXeFInNTDsVsclyqTfsfQiB3Br+F1A=";
=======
    sha256 = "sha256-/PiwrXr/oG/euWDOqcXvKKvyvQbp11Ks8LjmmJjDtdU=";
  };

  vendorSha256 = "sha256-aBGJ+JJjm9rt7Ic90iWY7vGtZQN0u6jlBnAMy1nivQM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "cmd/mtail" ];

  preBuild = ''
    go generate -x ./internal/vm/
  '';

  ldflags = [
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    license = licenses.asl20;
    homepage = "https://github.com/google/mtail";
    description = "Tool for extracting metrics from application logs";
  };
}
