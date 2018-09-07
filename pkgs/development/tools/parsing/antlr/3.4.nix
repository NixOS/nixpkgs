{stdenv, fetchurl, jre}:

stdenv.mkDerivation rec {
  name = "antlr-${version}";
  version = "3.4";
  src = fetchurl {
    url ="https://www.antlr3.org/download/antlr-${version}-complete.jar";
    sha256 = "1xqbam8vf04q5fasb0m2n1pn5dbp2yw763sj492ncq04c5mqcglx";
  };

  unpackPhase = "true";

  installPhase = ''
    mkdir -p "$out"/{lib/antlr,bin}
    cp "$src" "$out/lib/antlr/antlr-${version}-complete.jar"

    echo "#! ${stdenv.shell}" >> "$out/bin/antlr"
    echo "'${jre}/bin/java' -cp '$out/lib/antlr/antlr-${version}-complete.jar' -Xms200M -Xmx400M org.antlr.Tool \"\$@\"" >> "$out/bin/antlr"

    chmod a+x "$out/bin/antlr"
    ln -s "$out/bin/antlr"{,3}
  '';

  inherit jre;

  meta = with stdenv.lib; {
    description = "Powerful parser generator";
    longDescription = ''
      ANTLR (ANother Tool for Language Recognition) is a powerful parser
      generator for reading, processing, executing, or translating structured
      text or binary files. It's widely used to build languages, tools, and
      frameworks. From a grammar, ANTLR generates a parser that can build and
      walk parse trees.
    '';
    homepage = http://www.antlr.org/;
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
