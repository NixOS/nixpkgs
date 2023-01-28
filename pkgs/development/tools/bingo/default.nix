{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bingo";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "bwplotka";
    repo = "bingo";
    rev = "v${version}";
    hash = "sha256-s+vdtMzeHUtUlmMlvgnK83RYoMqS3GqrTnu7LssIK6A=";
  };

  vendorHash = "sha256-28p1g+p+guJ0x4/5QDGsGN6gDnZkE4AKF/2cFgNjPDM=";

  postPatch = ''
    rm get_e2e_test.go get_e2e_utils_test.go
  '';

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Like `go get` but for Go tools! CI Automating versioning of Go binaries in a nested, isolated Go modules.";
    homepage = "https://github.com/bwplotka/bingo";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
