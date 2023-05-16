{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "krew";
<<<<<<< HEAD
  version = "0.4.4";
=======
  version = "0.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "krew";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-SN6F7EmkgjtU4UHYPXWBiuXSSagjQYD6SBYBXRrSVGA=";
  };

  vendorHash = "sha256-3tEesDezIyB6005PZmOcrnEeAIvc5za3FxTmBBbKf7s=";
=======
    sha256 = "sha256-aW9yASskwDt+5Lvsdju9ZR/HeZ4x8heWljdhqK0ZTx8=";
  };

  vendorSha256 = "sha256-VXGjKzkOpaxyJClwXbxg15xmGdFi6arH8f4nN5/1SA4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/krew" ];

  meta = with lib; {
    description = "Package manager for kubectl plugins";
    homepage = "https://github.com/kubernetes-sigs/krew";
    maintainers = with maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
