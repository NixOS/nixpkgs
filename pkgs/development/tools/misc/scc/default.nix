{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "scc";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "scc";
    rev = "v${version}";
    hash = "sha256-WZWFgbC/Yz+KNYK+bjm+rlf3MJVPMbL+7hyFOSaSewA=";
  };

  vendorHash = null;

  # scc has a scripts/ sub-package that's for testing.
  excludedPackages = [ "scripts" ];

  meta = with lib; {
    homepage = "https://github.com/boyter/scc";
    description = "A very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go";
    maintainers = with maintainers; [ sigma Br1ght0ne ];
    license = with licenses; [ unlicense /* or */ mit ];
  };
}
