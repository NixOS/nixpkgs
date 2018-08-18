{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  name = "wireguard-go-${version}";
  version = "0.0.20180613";

  goPackagePath = "git.zx2c4.com/wireguard-go";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "0pvg7s1kyn48az54lsnyn1ryhjk0flmpz5dx520rc94g6xn88fic";
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
