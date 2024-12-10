{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
  SystemConfiguration,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "ferium";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "gorilla-devs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tYRs6HfFTdUZqWal9pLZ0uUNCPr3+zQz5JV2ohOLIP8=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  cargoHash = "sha256-5ClBS42hWw3ULEG1Qn+fiM6dvJ+xS4Dusy3BCj5Cvbg=";

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
    mainProgram = "ferium";
    homepage = "https://github.com/gorilla-devs/ferium";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      leo60228
      soupglasses
    ];
  };
}
