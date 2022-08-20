{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-toml";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-roEJMaRalvk/XT1f15R4DPnlkxo3hPDHdzOfDtZAa8Y=";
  };

  vendorSha256 = "sha256-yDPCfJtYty4aaoDrn3UWFcs1jHJHMJqzc5f06AWQmRc=";

  excludedPackages = [ "cmd/gotoml-test-decoder" "cmd/tomltestgen" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Go library for the TOML language";
    homepage = "https://github.com/pelletier/go-toml";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
