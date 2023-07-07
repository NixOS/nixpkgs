{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    hash = "sha256-67MHWJc4sOhOVe0n1RJLSez7SeUb79gGxjDqMrTuqFU=";
  };

  vendorHash = "sha256-qrRb8LRRmY5sZSSqsh0oSUq9MGYy7M8bgtBH8JPYQmc=";

  excludedPackages = [ "build" "man" ];

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = [ maintainers.vdemeester ];
  };
}
