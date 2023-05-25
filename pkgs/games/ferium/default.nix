{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "ferium";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "gorilla-devs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eaYXWOoeqCtdpxIFQxu3wJfYg8ZkuGB32/b2yzVW/Mc=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoHash = "sha256-5frotS85hwa24WRK6cVx1fmnolscKjRPkWoY6cnkbO8=";

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
    maintainers = with maintainers; [ leo60228 imsofi ];
  };
}
