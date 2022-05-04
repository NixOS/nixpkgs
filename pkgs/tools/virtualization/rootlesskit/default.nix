{ lib, buildGoModule, fetchFromGitHub, nix-update-script, nixosTests }:

buildGoModule rec {
  pname = "rootlesskit";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "rootlesskit";
    rev = "v${version}";
    hash = "sha256-Tml6zTc9l3O8qB+NSKlClWl5lj1rkiDHwI5exxBL83A=";
  };

  vendorSha256 = "sha256-CpDPa1LAinvXCnVYbn9ZXuEjyHHlDU4bzZ2R+ctoCzQ=";

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
