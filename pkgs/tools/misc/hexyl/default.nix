{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "hexyl";
<<<<<<< HEAD
  version = "0.13.1";
=======
  version = "0.13.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-+jmMy5Hi4EfMh/rBzBs5b+f48OZcR/Tw7IU1uTbwiCo=";
  };

  cargoHash = "sha256-TjJ0645TRlNzduQgxYLZWz+rLFfRv12GuwXBcmNr/h8=";
=======
    hash = "sha256-c3CMtPLo5NfKfr2meccFuDpf0ffZ3uBw995TEB5FSTs=";
  };

  cargoHash = "sha256-2pIASIJ83lFfC7do/02MxY/OOMJG7McS6O8uRMy9kVs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A command-line hex viewer";
    longDescription = ''
      `hexyl` is a simple hex viewer for the terminal. It uses a colored
      output to distinguish different categories of bytes (NULL bytes,
      printable ASCII characters, ASCII whitespace characters, other ASCII
      characters and non-ASCII).
    '';
    homepage = "https://github.com/sharkdp/hexyl";
    changelog = "https://github.com/sharkdp/hexyl/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir figsoda SuperSandro2000 ];
  };
}
