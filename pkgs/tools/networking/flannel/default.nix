{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "flannel";
  version = "0.27.3";
  rev = "v${version}";

  vendorHash = "sha256-JchHjQh1ZP6wdpgUwfNyhD93Wlf4FvCD0h4Tte47z3U=";

  src = fetchFromGitHub {
    inherit rev;
    owner = "flannel-io";
    repo = "flannel";
    sha256 = "sha256-r+9pII4zlPJ7UNdE0sR6Aul7p0sK+BRHq71S+NEekvM=";
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
