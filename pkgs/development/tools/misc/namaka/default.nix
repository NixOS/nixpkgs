{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, oniguruma
}:

rustPlatform.buildRustPackage rec {
  pname = "namaka";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "namaka";
    rev = "v${version}";
    hash = "sha256-CLGEW11Fo1v4vj0XSqiyW1EbhRZFO7dkgM43eKwItrk=";
  };

  cargoHash = "sha256-exftXTO/NbTfd7gNPpZ886jXH1XveqX+Cl/gXpZlS4c=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    GEN_ARTIFACTS = "artifacts";
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  postInstall = ''
    installManPage artifacts/*.1
    installShellCompletion artifacts/namaka.{bash,fish} --zsh artifacts/_namaka
  '';

  meta = with lib; {
    description = "Snapshot testing tool for Nix based on haumea";
    mainProgram = "namaka";
    homepage = "https://github.com/nix-community/namaka";
    changelog = "https://github.com/nix-community/namaka/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
