{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "20200109T185134";

  src = fetchurl {
    url = "https://github.com/snoe/clojure-lsp/releases/download/release-${version}/${pname}";
    sha256 = "11fzyf2qzqmxhdyssm59cqkkcjh8hw1i859abc1i2zali3fd7w68";
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
