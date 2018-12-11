with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "infer-v${version}";
  version = "0.15.0";

  # if source
  src = fetchurl {
    url = "https://github.com/facebook/infer/releases/download/v${version}/infer-osx-v${version}.tar.xz";
    sha256 = "0f87b8fd68b62717b8c3c143aeaea38b5102435f80fff484cb570a51cf510f9c";
  };

  # linux
  #url = "https://github.com/facebook/infer/releases/download/v0.15.0/infer-linux64-v0.15.0.tar.xz";
  #sha256 = "f6eb98162927735e8c545528bb5a472312e5defcf0761e43c07c73fe214cb18a";

  installPhase = ''
    mkdir -p $out/bin
    cp bin/infer* $out/bin/
  '';
}
