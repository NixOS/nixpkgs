{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

with lib;

buildGoModule rec {
  pname = "flannel";
  version = "0.17.0";
  rev = "v${version}";

  vendorSha256 = null;

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
    sha256 = "sha256-YM/cGmtHDTzgu6Bfy52oP8E1HmLNuBHNgEpz/qTj7rg=";
  };

  ldflags = [ "-X github.com/flannel-io/flannel/version.Version=${rev}" ];

  # TestRouteCache/TestV6RouteCache fail with "Failed to create newns: operation not permitted"
  doCheck = false;

  passthru.tests = { inherit (nixosTests) flannel; };

  meta = {
    description = "Network fabric for containers, designed for Kubernetes";
    license = licenses.asl20;
    homepage = "https://github.com/flannel-io/flannel";
    maintainers = with maintainers; [ johanot offline ];
    platforms = with platforms; linux;
  };
}
