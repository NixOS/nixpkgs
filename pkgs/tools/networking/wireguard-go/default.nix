{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  pname = "wireguard-go";
  version = "0.0.20200320";

  goPackagePath = "golang.zx2c4.com/wireguard";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "0fy4qsss3i3pkq1rpgjds4aipbwlh1dr9hbbf7jn2a1c63kfks0r";
  };

  patches = [ ./0001-Fix-darwin-build.patch ];

  goDeps = ./deps.nix;

  passthru.updateScript = ./update.sh;

  postInstall = ''
    mv $out/bin/wireguard $out/bin/wireguard-go
  '';

  meta = with stdenv.lib; {
    description = "Userspace Go implementation of WireGuard";
    homepage = "https://git.zx2c4.com/wireguard-go/about/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ elseym kirelagin yegortimoshenko zx2c4 ];
  };
}
