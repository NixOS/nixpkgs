{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gvproxy";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "gvisor-tap-vsock";
    rev = "v${version}";
    sha256 = "sha256-iRFjELJCgxPvqkhBvJqCFapQrHLL3uRpKsJ/DaXSKnw=";
  };

  vendorSha256 = null;

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
    description = "Network stack based on gVisor";
    homepage = "https://github.com/containers/gvisor-tap-vsock";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
  };
}
