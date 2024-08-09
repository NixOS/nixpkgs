{ lib, rustPlatform, fetchCrate, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.20.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ouyhdT6XTuWYBxi8HV0dWt/0dHml8YXjf2kzd90Eax0=";
  };

  cargoHash = "sha256-2R8dy9WnEPffkoJfQD8uFL0Ot3D2yibPxIjqRJ+6rMI=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage scraper.1
  '';

  meta = with lib; {
    description = "Tool to query HTML files with CSS selectors";
    mainProgram = "scraper";
    homepage = "https://github.com/causal-agent/scraper";
    changelog = "https://github.com/causal-agent/scraper/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ figsoda ];
  };
}
