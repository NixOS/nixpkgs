{ lib, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "golint";
  version = "unstable-2020-12-08";

  # we must allow references to the original `go` package, as golint uses
  # compiler go/build package to load the packages it's linting.
  allowGoReference = true;

  src = fetchgit {
    url = "https://go.googlesource.com/lint";
    rev = "83fdc39ff7b56453e3793356bcff3070b9b96445";
    sha256 = "sha256-g4Z9PREOxGoN7n/XhutawsITBznJlbz6StXeDYvOQ1c=";
  };

  vendorSha256 = "sha256-dPadFoymYu2Uw2AXZfbaBfxsN8IWMuK1TrcknHco3Bo=";

  # tests no longer work:
  # found packages pkg (4.go) and foo (blank-import-lib.go) in /build/lint-6edffad/testdata
  # testdata/errorf-custom.go:9:2: cannot find package "." in:
  #         /build/lint-6edffad/vendor/github.com/pkg/errors
  doCheck = false;

  meta = with lib; {
    homepage = "https://golang.org";
    description = "Linter for Go source code";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jhillyerd tomberek ];
  };
}
