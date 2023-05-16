{ lib, rustPlatform, fetchCrate, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
<<<<<<< HEAD
  version = "0.17.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-SVrQi9VxTzUHkdFdieOAIBhKvyrZqi3xKGooHkCEmhQ=";
  };

  cargoHash = "sha256-/Lut38gFO4XtrBHXr4sfcII+bWgcCDrHf5/PKPrDiDs=";
=======
  version = "0.16.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-3FxEfrScOetB1raiT9xjq9G2xLrLZqVlkqbVAFCIhZ0=";
  };

  cargoHash = "sha256-Pf8+vvOvOHpuJ2v7iwdVzHwneqvhk2E4nbGO4TL/FAM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage scraper.1
  '';

  meta = with lib; {
    description = "A tool to query HTML files with CSS selectors";
    homepage = "https://github.com/causal-agent/scraper";
    changelog = "https://github.com/causal-agent/scraper/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ figsoda ];
  };
}
