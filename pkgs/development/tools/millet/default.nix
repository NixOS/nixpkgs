{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6TFXaVIbdHO6smM20I2olURdBPZfcPBQ4Pyk5hU9Mx8=";
  };

  cargoSha256 = "sha256-fsguAk77XXMaGokqyGEumngBW2G4lmSU3Q2HMo5EtKY=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoBuildFlags = [ "--package" "lang-srv" ];

  cargoTestFlags = [ "--package" "lang-srv" ];

  meta = with lib; {
    description = "A language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/raw/v${version}/docs/changelog.md";
    license = [ licenses.mit /* or */ licenses.asl20 ];
    maintainers = with maintainers; [ marsam ];
    mainProgram = "lang-srv";
  };
}
