{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "lint";
  version = "20201208-${lib.strings.substring 0 7 rev}";
  rev = "83fdc39ff7b56453e3793356bcff3070b9b96445";

  # we must allow references to the original `go` package, as golint uses
  # compiler go/build package to load the packages it's linting.
  allowGoReference = true;

  src = fetchgit {
    inherit rev;
    url = "https://go.googlesource.com/lint";
    sha256 = "sha256-g4Z9PREOxGoN7n/XhutawsITBznJlbz6StXeDYvOQ1c=";
  };

  vendorSha256 = "sha256-dPadFoymYu2Uw2AXZfbaBfxsN8IWMuK1TrcknHco3Bo=";

  meta = with lib; {
    homepage = "https://golang.org";
    description = "Linter for Go source code";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jhillyerd tomberek ];
  };
}
