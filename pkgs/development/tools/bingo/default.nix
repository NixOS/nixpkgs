{ lib, buildGoModule, fetchFromGitHub, testVersion, bingo }:

buildGoModule rec {
  pname = "bingo";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "bwplotka";
    repo = "bingo";
    rev = "v${version}";
    sha256 = "sha256-4D8YaA/AH1gIp5iwD7WEAdBl73sqwHpfOe7bnxVcRcw=";
  };

  vendorSha256 = "sha256-xrz9FpwZd+FboVVTWSqGHRguGwrwE9cSFEEtulzbfDQ=";

  patches = [
    # Do not execute `go` command when invoking `bingo version`.
    ./version_go.patch
  ];

  postPatch = ''
    rm get_e2e_test.go get_e2e_utils_test.go
  '';

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testVersion {
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
