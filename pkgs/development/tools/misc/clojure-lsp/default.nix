{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "20200806T150857";

  src = fetchurl {
    url = "https://github.com/snoe/clojure-lsp/releases/download/release-${version}/${pname}";
    sha256 = "132w60p10ffr3vcykgw8rzxs54i6ynmw13p9nd59pqbn5adblrsp";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/clojure-lsp
    sed -i -e '1 s!java!${jre}/bin/java!' $out/bin/clojure-lsp
  '';

  # verify shebang patch
  installCheckPhase = "PATH= clojure-lsp --version";

  meta = with stdenv.lib; {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/snoe/clojure-lsp";
    license = licenses.mit;
    maintainers = [ maintainers.ericdallo ];
    platforms = jre.meta.platforms;
  };

}
