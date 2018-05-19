{ stdenv, buildGoPackage, fetchzip }:

buildGoPackage rec {
  name = "wireguard-go-${version}";
  version = "0.0.20180514";

  goPackagePath = "wireguard-go";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "1i1w4vj8w353b92nfhs92k0f7fifrwi067qfmgckdk0kk76nv2id";
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
    platforms = with platforms; linux ++ darwin ++ windows;
  };
}
