{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-open-on-gh";
<<<<<<< HEAD
  version = "2.4.1";
=======
  version = "2.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-d+8/7lli6iyzAWHIi0ahwPBwGhXrQrCKQisD2+jPHQ0=";
  };

  cargoHash = "sha256-WbPYrjDMJEwle+Pev5nr9ZhnycbXUjdrx8XAqQ0OpaM=";
=======
    hash = "sha256-K7SkfUxav/r8icrpdfnpFTSZdYV9qUEvYZ2dGSbaP0w=";
  };

  cargoHash = "sha256-Uvg0h0s3xtv/bVjqWLldvM/R5HQ6yoHdnBXvpUp/E3A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
