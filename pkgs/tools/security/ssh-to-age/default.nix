{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "ssh-to-age";
<<<<<<< HEAD
  version = "1.1.5";
=======
  version = "1.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "ssh-to-age";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-vER4PG2LFi/NM9TmCffqsF3aR4ZycwWVeKls2fNupo0=";
  };

  vendorHash = "sha256-g8qVV2cd7nxBN/BGNz28gJbtNkCUDJDdSdupXxhFw9Q=";
=======
    sha256 = "sha256-1YCo1Jm52S7hdJQFt/+OkdpWdvWP8eBsThZk5Gi4JiE=";
  };

  vendorHash = "sha256-L6mjCKMabnLRmiT8jcNCPEsTceYxRBHxhE0CpOvu3Sk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  checkPhase = ''
    runHook preCheck
    go test ./...
    runHook postCheck
  '';

  doCheck = true;

  meta = with lib; {
    description = "Convert ssh private keys in ed25519 format to age keys";
    homepage = "https://github.com/Mic92/ssh-to-age";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
<<<<<<< HEAD
    mainProgram = "ssh-to-age";
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
