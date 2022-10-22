{ lib, buildGoModule, fetchFromGitHub, nix-update-script, nixosTests }:

buildGoModule rec {
  pname = "rootlesskit";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
    hash = "sha256-wdg3pYsWHAEzQHy5LZYp0q9sOn7dmtcwOn94/0wYDa0=";
  };

  vendorSha256 = "sha256-OKqF9EutZP+6CFtANpNt21hGsz6GxuXcoaEqPKnoqeo=";

  passthru = {
    updateScript = nix-update-script { attrPath = pname; };
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
