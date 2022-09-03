{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghz";
  version = "0.109.0";

  src = fetchFromGitHub {
    owner = "bojand";
    repo = "ghz";
    rev = "v${version}";
    sha256 = "sha256-5l2PeN+VxTaORAkmAfI9TCGd4W6y8BFs/eY4T9nYJuc=";
  };

  vendorSha256 = "sha256-qZD+qxjjFgyQDtjOQcilS4w2sS9I+7iCK2/ThaAJTy4=";

  subPackages = [ "cmd/ghz" "cmd/ghz-web" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Simple gRPC benchmarking and load testing tool";
    homepage = "https://ghz.sh";
    license = licenses.asl20;
    maintainers = [ maintainers.zombiezen ];
  };
}
