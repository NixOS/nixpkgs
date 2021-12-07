{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

with lib;

buildGoModule rec {
  pname = "flannel";
  version = "0.15.1";
  rev = "v${version}";

  vendorSha256 = null;

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
    sha256 = "1p4rz4kdiif8i78zgxhw6dd0c1bq159f6l1idvig5apph7zi2bwm";
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
