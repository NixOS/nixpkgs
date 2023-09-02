{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-toml";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BEkshlB1Zze4sVo5YDwpj6ENHFLHL4IFmOIYgrWz+gQ=";
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
