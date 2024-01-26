{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "flannel";
  version = "0.24.2";
  rev = "v${version}";

  vendorHash = "sha256-vxzcFVFbbXeBb9kAJaAkvk26ptGo8CdnPJdcuC9qdF0=";

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
    sha256 = "sha256-pCgrIVB29OhegUuSuWVUaDWcLVI54FH5YlLjDcRf3j8=";
  };

  ldflags = [ "-X github.com/flannel-io/flannel/pkg/version.Version=${rev}" ];

  # TestRouteCache/TestV6RouteCache fail with "Failed to create newns: operation not permitted"
  doCheck = false;

  passthru.tests = { inherit (nixosTests) flannel; };

  meta = with lib; {
    description = "Network fabric for containers, designed for Kubernetes";
    license = licenses.asl20;
    homepage = "https://github.com/flannel-io/flannel";
    maintainers = with maintainers; [ johanot offline ];
    platforms = with platforms; linux;
  };
}
