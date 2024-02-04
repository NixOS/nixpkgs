{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "ferium";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "gorilla-devs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1avmzaIDz4/ARewB7yLYMBVtwdkY4FFfwcHAZSyg1Xc=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoHash = "sha256-IOnTJ/0mul7buBDNHkeqMM9NrFiX58xa03bVGrbAdNg=";

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
    maintainers = with maintainers; [ leo60228 soupglasses ];
  };
}
