{ stdenv, buildGoPackage, fetchurl }:

buildGoPackage rec {
  name = "wireguard-go-${version}";
  version = "0.0.20180514";

  goPackagePath = "wireguard-go";

  src = fetchurl {
    url = "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${version}.tar.xz";
    sha256 = "1bn49a67m2ab0l9lq3zh2mfbbppmyg34klqi3069sjn6lg2hlajs";
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
    platforms = with platforms; linux ++ darwin ++ windows;
  };
}
