{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "bingo";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "bwplotka";
    repo = "bingo";
    rev = "v${version}";
    hash = "sha256-bzh6P+J8EoewjOofwWXMgtSXAhESetD3y9EiqLNOT54=";
  };

  vendorHash = "sha256-cDeeRkTwuwEKNTqK/6ZEKANrjTIUTeR3o5oClkJQ4AE=";

  postPatch = ''
    rm get_e2e_test.go get_e2e_utils_test.go
  '';

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Like `go get` but for Go tools! CI Automating versioning of Go binaries in a nested, isolated Go modules";
    mainProgram = "bingo";
    homepage = "https://github.com/bwplotka/bingo";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
