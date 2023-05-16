{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "protoc-gen-twirp_php";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # fetchFromGitHub currently not possible, because go.mod and go.sum are export-ignored
  src = fetchgit {
    url = "https://github.com/twirphp/twirp.git";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-YMndB5DiER2Z1ARbw2cpxE1DBFCoVNWhMdsfA3X27EE=";
  };

  vendorHash = "sha256-Gf8thGuFAKX4pCNFJM3RbJ63vciLNcSqpOULcUOaGNw=";
=======
    sha256 = "sha256-6tA+iNcs6s4vviWSJ5gCL9hPyCa7OvYXRCCokAAO0T8=";
  };

  vendorSha256 = "sha256-Kz9tMM4XSMOUmlHb/BE5/C/ZohdE505DTeDj9lGki/I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "protoc-gen-twirp_php" ];

  ldflags = [
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "PHP port of Twitch's Twirp RPC framework";
    homepage = "https://github.com/twirphp/twirp";
    license = licenses.mit;
    maintainers = with maintainers; [ jojosch ];
  };
}
