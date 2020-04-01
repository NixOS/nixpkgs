{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  pname = "wireguard-go";
  version = "0.0.20200121";

  goPackagePath = "golang.zx2c4.com/wireguard";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "04ca1j8lcbyg1qg7ls23yy90s17k97i912ksxfpads0sdd3r2yc9";
  };

  patches = [ ./0001-Fix-darwin-build.patch ];

  goDeps = ./deps.nix;

  passthru.updateScript = ./update.sh;

  meta = with stdenv.lib; {
    description = "Userspace Go implementation of WireGuard";
    homepage = https://git.zx2c4.com/wireguard-go/about/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ elseym kirelagin yegortimoshenko zx2c4 ];
  };
}
