{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  name = "wireguard-go-${version}";
  version = "0.0.20181222";

  goPackagePath = "git.zx2c4.com/wireguard-go";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "00m1r97qrr4l21s5jk5m3xfpiybqbzgxp9failsy1nmx27wrdiky";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Userspace Go implementation of WireGuard";
    homepage = https://git.zx2c4.com/wireguard-go/about/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ elseym kirelagin yegortimoshenko zx2c4 ];
    platforms = platforms.darwin;
  };
}
