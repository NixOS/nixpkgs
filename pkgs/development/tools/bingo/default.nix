{ lib, buildGoModule, fetchFromGitHub, testers, bingo }:

buildGoModule rec {
  pname = "bingo";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "bwplotka";
    repo = "bingo";
    rev = "v${version}";
    sha256 = "sha256-t2nkY+mwek2NcbCwCkI3Mc1ULEJIjatBjChBdnKFAg8=";
  };

  vendorSha256 = "sha256-TCbwIHDg2YaLIscCoGPRBv5G3YSJ+qn/koOjPh+KKRY=";

  patches = [
    # Do not execute `go` command when invoking `bingo version`.
    ./version_go.patch
    # Specific to v0.6.0. `v0.6` -> `v0.6.0`
    ./bingo_version.patch
  ];

  postPatch = ''
    rm get_e2e_test.go get_e2e_utils_test.go
  '';

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = bingo;
    command = "bingo version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Like `go get` but for Go tools! CI Automating versioning of Go binaries in a nested, isolated Go modules.";
    homepage = "https://github.com/bwplotka/bingo";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
