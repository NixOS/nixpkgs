{ lib, rustPlatform, fetchCrate, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.14.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ucArD3xElLpOukNYHiErCTKDSlW2aDn00D3gr5L8Sm0=";
  };

  cargoSha256 = "sha256-62rJWpDi2vPHFnJnIrisyj0sEZTzRra+zoMb06zmxdE=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage scraper.1
  '';

  meta = with lib; {
    description = "A tool to query HTML files with CSS selectors";
    homepage = "https://github.com/causal-agent/scraper";
    license = licenses.isc;
    maintainers = with maintainers; [ figsoda ];
  };
}
