{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  name = "wireguard-go-${version}";
  version = "0.0.20180519";

  goPackagePath = "wireguard-go";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "d2b0f43679b3559952cf8d244d537903d03699ed7c8a2c1e7fc37ee424e30439";
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
    maintainers = with maintainers; [ kirelagin ];
    platforms = with platforms; darwin;
  };
}
