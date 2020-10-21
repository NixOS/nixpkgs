{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "20201009T224414";

  src = fetchurl {
    url = "https://github.com/snoe/clojure-lsp/releases/download/release-${version}/${pname}";
    sha256 = "1az87b4cq6yyibs4knd0ywd0qfgmfzai4bqry4b7h2ycnfhfxdpa";
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
