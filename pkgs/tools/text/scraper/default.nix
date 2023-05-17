{ lib, rustPlatform, fetchCrate, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.16.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-3FxEfrScOetB1raiT9xjq9G2xLrLZqVlkqbVAFCIhZ0=";
  };

  cargoHash = "sha256-Pf8+vvOvOHpuJ2v7iwdVzHwneqvhk2E4nbGO4TL/FAM=";

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
