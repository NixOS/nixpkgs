{ lib, buildGoModule, fetchFromGitHub, nix-update-script, nixosTests }:

buildGoModule rec {
  pname = "rootlesskit";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
    hash = "sha256-qcVgLhBUVZTvXz5/QytYWzYtCKscBab/Iy25KAgzExo=";
  };

  vendorHash = "sha256-ctZt0jkBhQPryEKCrd1a+ymnVKkGasZV6gOtR5U0L0I=";

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
