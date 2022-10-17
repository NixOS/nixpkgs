{ lib, rustPlatform, fetchCrate, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "scraper";
  version = "0.13.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-5fFO51I6DqH1BBELt9FW2BCwYcsXVXaQLgocMn446Bs=";
  };

  cargoSha256 = "sha256-Y4m7C7v4ekJfb3BoWwDF+X8uuRH9muaTwPECgu4WaMQ=";

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
