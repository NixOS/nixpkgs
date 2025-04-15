{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "flannel";
  version = "0.26.6";
  rev = "v${version}";

  vendorHash = "sha256-cD5NDK0jb1dKhNRiYTaU36TM3CdkwScZ24AtkaEja4k=";

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
    sha256 = "sha256-IVez0Df+OAWSoIQ6cgBNG5qC48T7mhWN2OVRaVxbAr4=";
  };

  ldflags = [ "-X github.com/flannel-io/flannel/pkg/version.Version=${rev}" ];

  # TestRouteCache/TestV6RouteCache fail with "Failed to create newns: operation not permitted"
  doCheck = false;

  passthru.tests = { inherit (nixosTests) flannel; };

  meta = with lib; {
    description = "Network fabric for containers, designed for Kubernetes";
    license = licenses.asl20;
    homepage = "https://github.com/flannel-io/flannel";
    maintainers = with maintainers; [
      johanot
      offline
    ];
    platforms = with platforms; linux;
    mainProgram = "flannel";
  };
}
