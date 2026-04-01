{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "flannel";
  version = "0.28.2";
  rev = "v${version}";

  vendorHash = "sha256-80hrkaY2Kh318EX1Mosm1GP7aXYKvAdPAe+6LR8yuEk=";

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
    sha256 = "sha256-/vw5534Ve8P5hiVmSiMD/lbns8zq2h3WCEZXB56ha4E=";
  };

  ldflags = [ "-X github.com/flannel-io/flannel/pkg/version.Version=${rev}" ];

  # TestRouteCache/TestV6RouteCache fail with "Failed to create newns: operation not permitted"
  doCheck = false;

  passthru.tests = { inherit (nixosTests) flannel; };

  meta = {
    description = "Network fabric for containers, designed for Kubernetes";
    license = lib.licenses.asl20;
    homepage = "https://github.com/flannel-io/flannel";
    maintainers = with lib.maintainers; [
      johanot
      offline
    ];
    platforms = with lib.platforms; linux;
    mainProgram = "flannel";
  };
}
