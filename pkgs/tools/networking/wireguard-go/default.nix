{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  name = "wireguard-go-${version}";
  version = "0.0.20180519";

  goPackagePath = "wireguard-go";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "0b3wpc0ccf24567fjafv1sjs3yqq1xjam3gpfp37avxqy9789nb7";
  };

  goDeps = ./deps.nix;

  postPatch = ''
    # Replace local imports so that go tools do not trip on them
    find . -name '*.go' -exec sed -i '/import (/,/)/s@"./@"${goPackagePath}/@' {} \;
  '';

  meta = with stdenv.lib; {
    description = "Userspace Go implementation of WireGuard";
    homepage = https://git.zx2c4.com/wireguard-go/about/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ kirelagin zx2c4 ];
    platforms = platforms.darwin;
  };
}
