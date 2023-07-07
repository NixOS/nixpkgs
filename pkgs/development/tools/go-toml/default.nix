{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-toml";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "pelletier";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pMy/cYyB9ncOuYysX0a9PmTuJdIrMcKL///57bniixI=";
  };

  vendorHash = "sha256-44mxDswHIfVfAyvtyDHS4MnHCTPRlUvdhzHALICUJR4=";

  excludedPackages = [ "cmd/gotoml-test-decoder" "cmd/tomltestgen" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Go library for the TOML language";
    homepage = "https://github.com/pelletier/go-toml";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
