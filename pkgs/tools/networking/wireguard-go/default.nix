{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  name = "wireguard-go-${version}";
  version = "0.0.20181001";

  goPackagePath = "git.zx2c4.com/wireguard-go";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "0yh9f58xn8kcq3wgx2s8j19k2h1vbmg70fn5gvw9k98f5mzynls3";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Userspace Go implementation of WireGuard";
    homepage = https://git.zx2c4.com/wireguard-go/about/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ kirelagin yegortimoshenko zx2c4 ];
    platforms = platforms.darwin;
  };
}
