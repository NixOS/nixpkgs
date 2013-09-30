{ fetchurl, stdenv, ant, jdk }:

stdenv.mkDerivation rec {
  name = "fop-1.1";

  src = fetchurl {
    url = "http://apache.uib.no/xmlgraphics/fop/source/${name}-src.tar.gz";
    sha256 = "08i56d57w5dl5bqchr34x9165hvi5h4bhiflxhi0a4wd56rlq5jq";
  };

  buildInputs = [ ant jdk ];

  buildPhase = ''
    ant
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"
    mkdir -p "$out/share/doc/fop"

    cp build/*.jar lib/*.jar "$out/lib/"
    cp -r README examples/ "$out/share/doc/fop/"

    # There is a fop script in the source archive, but it has many impurities.
    # Instead of patching out 90 % of the script, we write our own.
    cat > "$out/bin/fop" <<EOF
    #!${stdenv.shell}
    java_exec_args="-Djava.awt.headless=true"
    # Note the wildcard; it will be passed to java and java will expand it
    LOCALCLASSPATH="$out/lib/*"
    exec "${jdk}/bin/java" \$java_exec_args -classpath "\$LOCALCLASSPATH" org.apache.fop.cli.Main "\$@"
    EOF
    chmod a+x "$out/bin/fop"
  '';

  meta = with stdenv.lib; {
    description = "XML formatter driven by XSL Formatting Objects (XSL-FO)";
    longDescription = ''
      FOP is a Java application that reads a formatting object tree and then
      turns it into a wide variety of output presentations (including AFP, PCL,
      PDF, PNG, PostScript, RTF, TIFF, and plain text), or displays the result
      on-screen.

      The formatting object tree can be in the form of an XML document (output
      by an XSLT engine like xalan) or can be passed in memory as a DOM
      Document or (in the case of xalan) SAX events.

      This package contains the fop command line tool.
    '';
    homepage = http://xmlgraphics.apache.org/fop/;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
