{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kopia";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wQZzFrrxLzJ16TOrhxBlUuz+eCdqW/PmHUTuJP1Wy9Y=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-OeDgaO125y8eCQlm9Lv5RZlb1fNLTCplEQbpJ2KMVms=";
=======
  vendorSha256 = "sha256-OeDgaO125y8eCQlm9Lv5RZlb1fNLTCplEQbpJ2KMVms=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [
    "-X github.com/kopia/kopia/repo.BuildVersion=${version}"
    "-X github.com/kopia/kopia/repo.BuildInfo=${src.rev}"
  ];

  meta = with lib; {
    homepage = "https://kopia.io";
    description = "Cross-platform backup tool with fast, incremental backups, client-side end-to-end encryption, compression and data deduplication";
    license = licenses.asl20;
    maintainers = [ maintainers.bbigras ];
  };
}
