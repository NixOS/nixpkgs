{ lib, buildGoModule, fetchFromGitHub, nix-update-script, nixosTests }:

buildGoModule rec {
  pname = "rootlesskit";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
    hash = "sha256-MFGeJz1VZ7ciraQCArWMXPsp8+ROJMP6Hbep+IVLyVo=";
  };

  vendorHash = "sha256-5uttr9cmnLa1Kp7UyP0/KCktr8MxWCRnSZ52ijY6+eE=";

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
