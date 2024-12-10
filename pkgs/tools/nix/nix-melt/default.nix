{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-melt";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-melt";
    rev = "v${version}";
    hash = "sha256-5V9sPbBb9t4B6yiLrYF+hx6YokGDH6+UsVQBhgqxMbY=";
  };

  cargoHash = "sha256-yBoaLqynvYC9ebC0zjd2FmSSd53xzn4ralihtCFubAw=";

  nativeBuildInputs = [
    installShellFiles
  ];

  env = {
    GEN_ARTIFACTS = "artifacts";
  };

  postInstall = ''
    installManPage artifacts/nix-melt.1
    installShellCompletion artifacts/nix-melt.{bash,fish} --zsh artifacts/_nix-melt
  '';

  meta = with lib; {
    description = "A ranger-like flake.lock viewer";
    mainProgram = "nix-melt";
    homepage = "https://github.com/nix-community/nix-melt";
    changelog = "https://github.com/nix-community/nix-melt/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
