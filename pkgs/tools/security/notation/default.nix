{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "notation";
  version = "1.0.0-rc.7";

  src = fetchFromGitHub {
    owner = "notaryproject";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EM2QunSL88Am3zgKwgI94jET3xaVfvsa4MCtMZ3ejjU=";
  };

  vendorHash = "sha256-88PCnIm7nQB8jLzrfVOyDLXWX7RZeT31n1cwvb4Qza0=";

  # This is a Go sub-module and cannot be built directly (e2e tests).
  excludedPackages = [ "./test" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "CLI tool to sign and verify OCI artifacts and container images";
    homepage = "https://notaryproject.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
