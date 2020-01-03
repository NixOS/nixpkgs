{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  pname = "wireguard-go";
  version = "0.0.20190908";

  goPackagePath = "golang.zx2c4.com/wireguard";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "1jsch0157nk86krdknij7dsvg6i7ar0ydhy07r40drhxqyp3q0hx";
  };

  goDeps = ./deps.nix;

  passthru.updateScript = ./update.sh;

  meta = with stdenv.lib; {
    description = "Userspace Go implementation of WireGuard";
    homepage = https://git.zx2c4.com/wireguard-go/about/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ elseym kirelagin yegortimoshenko zx2c4 ];
  };
}
