{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "20200117T215443";

  src = fetchurl {
    url = "https://github.com/snoe/clojure-lsp/releases/download/release-${version}/${pname}";
    sha256 = "0ccn3700lam5m5yh5hdcm6wkazyr3dhvhyc9bc08basjwk09lfkp";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/clojure-lsp
  '';

  meta = with stdenv.lib; {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/snoe/clojure-lsp";
    license = licenses.mit;
    maintainers = [ maintainers.ericdallo ];
    platforms = jre.meta.platforms;
  };

}
