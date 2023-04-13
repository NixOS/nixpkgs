{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, oniguruma
}:

rustPlatform.buildRustPackage rec {
  pname = "namaka";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "namaka";
    rev = "v${version}";
    hash = "sha256-1B9FWdRxDM9PykfK9LKGZcwIc+sJNAZlvBh6G9dCHW4=";
  };

  cargoHash = "sha256-k9FDpugRCdvJ3E+gI1tO73RXRef8lg/txOAPDrE0+XM=";

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
    homepage = "https://github.com/nix-community/namaka";
    changelog = "https://github.com/nix-community/namaka/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
