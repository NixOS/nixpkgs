{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-toml";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SnSdVBIIir7QSexk//ozpxnbNr92KyWP2sSBg87jGcw=";
  };

  vendorHash = "sha256-XOcCsb3zUChiYLTfOCbRQF71E2khzSt/ApFI8NAS13U=";

  excludedPackages = [ "cmd/gotoml-test-decoder" "cmd/tomltestgen" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Go library for the TOML language";
    homepage = "https://github.com/pelletier/go-toml";
    changelog = "https://github.com/pelletier/go-toml/releases/tag/v${version}";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
