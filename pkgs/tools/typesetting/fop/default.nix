{ fetchurl, stdenv, ant, jdk }:

stdenv.mkDerivation rec {
  name = "fop-${version}";
  version = "2.1";

  src = fetchurl {
    url = "mirror://apache/xmlgraphics/fop/source/${name}-src.tar.gz";
    sha256 = "165rx13q47l6qc29ppr7sg1z26vw830s3rkklj5ap7wgvy0ivbz5";
  };

  buildInputs = [ ant jdk ];

  buildPhase = "ant";

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/share/doc/fop

    cp build/*.jar lib/*.jar $out/lib/
    cp -r README examples/ $out/share/doc/fop/

    # There is a fop script in the source archive, but it has many impurities.
    # Instead of patching out 90 % of the script, we write our own.
    cat > "$out/bin/fop" <<EOF
    #!${stdenv.shell}
    java_exec_args="-Djava.awt.headless=true"
    exec ${jdk.jre}/bin/java \$java_exec_args -classpath "$out/lib/*" org.apache.fop.cli.Main "\$@"
    EOF
    chmod a+x $out/bin/fop
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
    maintainers = with maintainers; [ bjornfor ndowens ];
  };
}
