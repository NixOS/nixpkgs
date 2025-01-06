{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "chars";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "antifuchs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mBtwdPzIc6RgEFTyReStFlhS4UhhRWjBTKT6gD3tzpQ=";
  };

  cargoHash = "sha256-wqyExG4haco6jg1zpbouz3xMR7sjiVIAC16PnDU2tc8=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Commandline tool to display information about unicode characters";
    mainProgram = "chars";
    homepage = "https://github.com/antifuchs/chars";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bbigras ];
  };
}
