{
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.19.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-HfZ8zyjghTXIyIYS+MaGF5OdMLJv6NIjQswdn/tvQbU=";
  };

  cargoHash = "sha256-py8VVciNJ36/aSTlTH+Bx36yrh/8AuzB9XNNv/PrFak=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage scraper.1
  '';

  meta = with lib; {
    description = "A tool to query HTML files with CSS selectors";
    mainProgram = "scraper";
    homepage = "https://github.com/causal-agent/scraper";
    changelog = "https://github.com/causal-agent/scraper/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ figsoda ];
  };
}
