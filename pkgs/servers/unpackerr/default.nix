{ lib, stdenv, fetchFromGitHub, buildGoModule, Cocoa, WebKit }:

buildGoModule rec {
  pname = "unpackerr";
<<<<<<< HEAD
  version = "0.12.0";
=======
  version = "0.11.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "davidnewhall";
    repo = "unpackerr";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-yMmn733j6k9r8I/lvVOZNL6o35eSPJZ5G8jw9xaJZRg=";
  };

  vendorHash = "sha256-1VMeRB34JS9EwyGhPxFsRIgKaY6NyIMsa132PQKoPYY=";
=======
    sha256 = "sha256-Jxg1gaMTJ/BbL8TQfPcyt1hYnT/LcL4j+m+jSeh5QyA=";
  };

  vendorHash = "sha256-yXFIBWOF72nXmT8+OSvF1aKBhCMBloLmGTfvNbV9ir4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa WebKit ];

  ldflags = [ "-s" "-w" "-X golift.io/version.Version=${version}" ];

  meta = with lib; {
    description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
    homepage = "https://github.com/davidnewhall/unpackerr";
    maintainers = with maintainers; [ nullx76 ];
    license = licenses.mit;
  };
}
