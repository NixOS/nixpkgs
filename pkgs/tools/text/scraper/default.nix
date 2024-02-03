{ lib, rustPlatform, fetchCrate, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.18.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/OVUtRQH6Sc0TggN8UEA1GhVD4dXv8h5MFAXswgwSFE=";
  };

  cargoHash = "sha256-zi6Jgibrx5kckqTj4nHBtiCFuHYmz4cyMwFkNQ6VXjc=";

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
