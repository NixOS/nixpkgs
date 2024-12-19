{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  Security,
}:

rustPlatform.buildRustPackage rec {
  # Renaming it to amber-secret because another package named amber exists
  pname = "amber-secret";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "fpco";
    repo = "amber";
    rev = "v${version}";
    sha256 = "sha256-nduSnDhLvHpZD7Y1zeZC4nNL7P1qfLWc0yMpsdqrKHM=";
  };

  cargoHash = "sha256-DxTsbJ51TUMvc/NvsUYhRG9OxxEGrWfEPYCOYaG9PXo=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  meta = with lib; {
    description = "Manage secret values in-repo via public key cryptography";
    homepage = "https://github.com/fpco/amber";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
    mainProgram = "amber";
  };
}
