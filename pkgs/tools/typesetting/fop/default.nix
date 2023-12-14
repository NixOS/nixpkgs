{ fetchurl, lib, stdenv, ant, jdk, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "fop";
  version = "2.8";

  src = fetchurl {
    url = "mirror://apache/xmlgraphics/fop/source/${pname}-${version}-src.tar.gz";
    sha256 = "sha256-b7Av17wu6Ar/npKOiwYqzlvBFSIuXTpqTacM1sxtBvc=";
  };

  buildInputs = [ ant jdk ];

  # build only the "package" target, which generates the fop command.
  buildPhase = ''
     export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"
     ant -f fop/build.xml package
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/share/doc/fop
    cp fop/build/*.jar fop/lib/*.jar $out/lib/
    cp -r README fop/examples/ $out/share/doc/fop/

    # There is a fop script in the source archive, but it has many impurities.
    # Instead of patching out 90 % of the script, we write our own.
    cat > "$out/bin/fop" <<EOF
    #!${runtimeShell}
    java_exec_args="-Djava.awt.headless=true"
    exec ${jdk.jre}/bin/java \$java_exec_args -classpath "$out/lib/*" org.apache.fop.cli.Main "\$@"
    EOF
    chmod a+x $out/bin/fop
  '';

  meta = with lib; {
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
    homepage = "https://xmlgraphics.apache.org/fop/";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # source bundles dependencies as jars
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ bjornfor ];
    mainProgram = "fop";
  };
}
