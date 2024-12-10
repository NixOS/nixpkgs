{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  openssl,
  pkg-config,
  Security,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "twm";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "vinnymeller";
    repo = "twm";
    rev = "v${version}";
    hash = "sha256-1hRGcvUGHO5ENgI3tdT46736ODN8QZ6vg+Y1y2XeuAA=";
  };

  cargoHash = "sha256-iJB+7+1tFT/tKvXlxaaW3QJHjWNZmCVIEXwtrSei/Do=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Customizable workspace manager for tmux";
    homepage = "https://github.com/vinnymeller/twm";
    changelog = "https://github.com/vinnymeller/twm/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vinnymeller ];
    mainProgram = "twm";
  };
}
