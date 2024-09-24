{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gvproxy";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "gvisor-tap-vsock";
    rev = "v${version}";
    hash = "sha256-A2nG3Or5EhUSjTIpV05rWVcLJpGHtAWP5/n07KjM/E8=";
  };

  vendorHash = null;

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install bin/* -Dt $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/containers/gvisor-tap-vsock/releases/tag/${src.rev}";
    description = "Network stack based on gVisor";
    homepage = "https://github.com/containers/gvisor-tap-vsock";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
  };
}
