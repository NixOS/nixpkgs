{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "causal-agent";
    repo = "scraper";
    rev = "v${version}";
    hash = "sha256-K0MeZeS60gxo0/kBCaffNVQrR5S1HDoq77hnC//LMQg=";
  };

  cargoHash = "sha256-2IvfJaYyX7ZA1y3TETydb7wXRER4CfH69xEvnxKCFTc=";

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
