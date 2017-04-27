{ stdenv, lib, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "ammonite-repl-${version}";
  version = "0.8.3";

  src = fetchurl {
    url = "https://github.com/lihaoyi/Ammonite/releases/download/${version}/2.12-${version}";
    sha256 = "0y4524y2w7aq300djcazb7ckkr3gqpim2grcgb237mxq3fdvb0r8";
  };

  propagatedBuildInputs = [ jre ] ;
  buildInputs = [ makeWrapper ] ;

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/amm
    chmod +x $out/bin/amm
    wrapProgram $out/bin/amm --prefix PATH ":" ${jre}/bin ;
  '';

  meta = {
    description = "Improved Scala REPL";
    longDescription = ''
        The Ammonite-REPL is an improved Scala REPL, re-implemented from first principles.
        It is much more featureful than the default REPL and comes
        with a lot of ergonomic improvements and configurability
        that may be familiar to people coming from IDEs or other REPLs such as IPython or Zsh.
    '';
    homepage = http://www.lihaoyi.com/Ammonite/;
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainer = [ lib.maintainers.nequissimus ];
  };
}
