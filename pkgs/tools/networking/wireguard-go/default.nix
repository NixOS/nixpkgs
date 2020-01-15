{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  pname = "wireguard-go";
  version = "0.0.20190517";

  goPackagePath = "git.zx2c4.com/wireguard-go";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "0ir3dp13vkkqr76q0jvw610qw40053ngk51psqhqxfaw3jicdqgr";
  };

  goDeps = ./deps.nix;

  passthru.updateScript = ./update.sh;

  meta = with stdenv.lib; {
    description = "Userspace Go implementation of WireGuard";
    homepage = https://git.zx2c4.com/wireguard-go/about/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ elseym kirelagin yegortimoshenko zx2c4 ];
    platforms = platforms.darwin;
  };
}
