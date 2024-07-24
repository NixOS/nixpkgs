{ lib, rustPlatform, fetchCrate, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.19.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-RxNnKejGd5Jr7ZOXnYGHbV/0mS2e4zKzSpTbsyOPXqw=";
  };

  cargoHash = "sha256-ld+1O+oYGm/R+bCK/pEc/pDl/ev1zEp8HgSOkilgWgk=";

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
