{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "20200114T225020";

  src = fetchurl {
    url = "https://github.com/snoe/clojure-lsp/releases/download/release-${version}/${pname}";
    sha256 = "1fx27nz79h1f3gmaw9k33dq9r28s7z8rx6hqpv44368v67d8jbhb";
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
