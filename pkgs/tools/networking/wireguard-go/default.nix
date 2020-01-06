{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  pname = "wireguard-go";
  version = "0.0.20191012";

  goPackagePath = "golang.zx2c4.com/wireguard";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "0s3hvqpz13n630yvi0476hfzrp3xcj8x61zc2hl5z70f8kvbay4i";
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
