<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "restic-rest-server";
  version = "0.12.1";
=======
{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "restic-rest-server";
  version = "0.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "restic";
    repo = "rest-server";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-0zmUI7LUKVXUdPsNxY7RQxbsAraY0GrTMAS3kORIU6I=";
  };

  vendorHash = "sha256-tD5ffIYULMBqu99l1xCL0RnLB9zNpwNPs1qVFqezUc8=";
=======
    hash = "sha256-FnT7AG9na/KdWimUqhcF1QndGdT+Nc8ao5zlSeN/fJ0=";
  };

  vendorHash = "sha256-Q0XazJmfmAwR2wXD/RXO6nPiNyWFubBYL3kNFKBRMzc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    changelog = "https://github.com/restic/rest-server/blob/${src.rev}/CHANGELOG.md";
    description = "A high performance HTTP server that implements restic's REST backend API";
    homepage = "https://github.com/restic/rest-server";
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
  };
}
