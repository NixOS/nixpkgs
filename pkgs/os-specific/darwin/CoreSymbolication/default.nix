{ fetchFromGitHub, stdenv }:

# Reverse engineered CoreSymbolication to make dtrace buildable

stdenv.mkDerivation rec {
  name = "CoreSymbolication";

  src = fetchFromGitHub {
    repo = name;
    owner = "matthewbauer";
    rev = "671fcb66c82eac1827f3f53dc4cc4e9b1b94da0a";
    sha256 = "0qpw46gwgjxiwqqjxksb8yghp2q8dwad6hzaf4zl82xpvk9n5ahj";
  };

  installPhase = ''
    mkdir -p $out/include
    cp -r CoreSymbolication $out/include
  '';
}
