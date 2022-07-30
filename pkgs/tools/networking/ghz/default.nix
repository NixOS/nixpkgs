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
  
  proxyVendor = true;
  vendorSha256 = "sha256-R1OB4jTmyyS2O91vqSNjmSA19KutHzPLcLQ7R7tCsIA=";

  subPackages = ["cmd/ghz" "cmd/ghz-web"];

ldflags = [ "-s" "-w" ];

  meta = {
    description = "Simple gRPC benchmarking and load testing tool";
    homepage = "https://ghz.sh";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.zombiezen ];
  };
}
