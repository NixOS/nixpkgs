{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "rsass";
  version = "0.28.8";

  src = fetchCrate {
    pname = "rsass-cli";
    inherit version;
    hash = "sha256-eloTe7UHcPPmHEsGnfj3nIbZbBxSMFZdaSm5LpOh1S4=";
  };

  cargoHash = "sha256-57vqVKqwQOEB33cSzGiZwadTDi7EyBBRAS4X9Euwp5Q=";

  meta = with lib; {
    description = "Sass reimplemented in rust with nom";
    mainProgram = "rsass";
    homepage = "https://github.com/kaj/rsass";
    changelog = "https://github.com/kaj/rsass/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
