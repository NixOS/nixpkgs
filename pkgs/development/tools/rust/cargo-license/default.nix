{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-license";
  version = "0.6.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-qwyWj0vPWQOZYib2ZZutX25a4wwnG1kFAiRCWqGyVms=";
  };

  cargoHash = "sha256-ifw/n7eejUWUqhieDLojuO3xgosn28NnjAKkq/ZSLEI=";

  meta = with lib; {
    description = "Cargo subcommand to see license of dependencies";
    mainProgram = "cargo-license";
    homepage = "https://github.com/onur/cargo-license";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ basvandijk figsoda matthiasbeyer ];
  };
}
