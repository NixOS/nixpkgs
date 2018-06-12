{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  name = "wireguard-go-${version}";
  version = "0.0.20180531";

  goPackagePath = "git.zx2c4.com/wireguard-go";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "1vs11kr5a2s99v0g7079nfrfvmjfh1p2lnkj2icjyn2cb0s1vqiy";
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
