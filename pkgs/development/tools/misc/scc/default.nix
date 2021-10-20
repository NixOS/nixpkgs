{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "scc";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "scc";
    rev = "v${version}";
    sha256 = "sha256-G5LYOtAUnu82cgDdtYzcfVx/WFg9/HvFQAlQtd6GaDE=";
  };

  vendorSha256 = null;

  # scc has a scripts/ sub-package that's for testing.
  excludedPackages = [ "scripts" ];

  meta = with lib; {
    homepage = "https://github.com/boyter/scc";
    description = "A very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go";
    maintainers = with maintainers; [ sigma Br1ght0ne ];
    license = with licenses; [ unlicense /* or */ mit ];
    platforms = platforms.unix;
  };
}
