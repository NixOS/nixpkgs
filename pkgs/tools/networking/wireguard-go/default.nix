{ lib, buildGoPackage, fetchzip }:

buildGoPackage rec {
  pname = "wireguard-go";
  version = "0.0.20210424";

  goPackagePath = "golang.zx2c4.com/wireguard";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "RUUueSsfEi1H+ckrnPKqbVlWONhCplMMftlyAmwK+ss=";
  };

  goDeps = ./deps.nix;

  passthru.updateScript = ./update.sh;

  postInstall = ''
    mv $out/bin/wireguard $out/bin/wireguard-go
  '';

  doCheck = true;

  meta = with lib; {
    description = "Userspace Go implementation of WireGuard";
    homepage = "https://git.zx2c4.com/wireguard-go/about/";
    license = licenses.mit;
    maintainers = with maintainers; [ elseym kirelagin yegortimoshenko zx2c4 ];
  };
}
