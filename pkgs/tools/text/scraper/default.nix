{ lib, rustPlatform, fetchCrate, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.18.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-fnX2v7VxVFgn9UT1+qWBvN+oDDI2DbK6UFKmby5aB5c=";
  };

  cargoHash = "sha256-HeT3U4H/OM/91BdXTvZq+gpmOnt/P4wTlqc2dl4erlQ=";

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
