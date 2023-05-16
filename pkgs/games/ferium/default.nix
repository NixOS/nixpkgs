{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "ferium";
<<<<<<< HEAD
  version = "4.4.1";
=======
  version = "4.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "gorilla-devs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-3ILDR6CmR/CTzZfUEPD10TQZRSDKSqHmwxU3GPHIyK8=";
=======
    sha256 = "sha256-eaYXWOoeqCtdpxIFQxu3wJfYg8ZkuGB32/b2yzVW/Mc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

<<<<<<< HEAD
  cargoHash = "sha256-00rzn8eWcxRfPvIT2+EVQLd6e8gnMWx78QrwURpxstg=";
=======
  cargoHash = "sha256-5frotS85hwa24WRK6cVx1fmnolscKjRPkWoY6cnkbO8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Disable the GUI file picker so that GTK/XDG dependencies aren't used
  buildNoDefaultFeatures = true;

  # Requires an internet connection
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/ferium complete $shell > ferium.$shell
      installShellCompletion ferium.$shell
    done
  '';

  meta = with lib; {
    description = "Fast and multi-source CLI program for managing Minecraft mods and modpacks from Modrinth, CurseForge, and GitHub Releases";
    homepage = "https://github.com/gorilla-devs/ferium";
    license = licenses.mpl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ leo60228 soupglasses ];
=======
    maintainers = with maintainers; [ leo60228 imsofi ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
