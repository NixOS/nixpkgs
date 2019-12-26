{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "20191223T204324";

  src = fetchurl {
    url = "https://github.com/snoe/clojure-lsp/releases/download/release-${version}/${pname}";
    sha256 = "1dcqn72szp4q3b591plby6vzv0xl3ik0hr5wiha3hfb8lm7y6inn";
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
