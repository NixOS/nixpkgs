{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule rec {
  pname = "rootlesskit";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
    hash = "sha256-SWLXY7SsoeJFr2RLOtVSnt5Knx44+9hNIy50NzN602k=";
  };

  vendorHash = "sha256-74El20C7kE0lLAng9wQL7MnfcJLtPR2cAk00CuO4NlY=";

  passthru = {
    updateScript = nix-update-script { };
    tests = nixosTests.docker-rootless;
  };

  meta = with lib; {
    homepage = "https://github.com/rootless-containers/rootlesskit";
    description = ''Kind of Linux-native "fake root" utility, made for mainly running Docker and Kubernetes as an unprivileged user'';
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
