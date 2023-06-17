{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "flannel";
  version = "0.21.5";
  rev = "v${version}";

  vendorHash = "sha256-JtDFwkYRAxpa4OBV5Tzr70DcOsp2oA3XB0PM5kGaY6Q=";

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
    sha256 = "sha256-X8NVAaKJrJF1OCfzwcydvDPFUOhwdgGy/wfMWdhUqQ0=";
  };

  ldflags = [ "-X github.com/flannel-io/flannel/version.Version=${rev}" ];

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
