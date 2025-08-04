{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "flannel";
  version = "0.27.2";
  rev = "v${version}";

  vendorHash = "sha256-48/BYhVWS/Tp1UKgpGX31/gdMC1xpWr06+Y+WoXPAs4=";

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
    sha256 = "sha256-d92kv1cWwZr4BzrFaI3t/JBvYERaClqFSRzrAUFkqRc=";
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
