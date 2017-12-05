{ stdenv, fetchurl, jre, unzip }:

stdenv.mkDerivation rec {
  major = "14";
  minor = "2";
  version = "${major}.${minor}";
  name = "umlet-${version}";

  src = fetchurl {
    url = "http://www.umlet.com/umlet_${major}_${minor}/umlet-standalone-${version}.zip";
    sha256 = "1fcc7ms92vcc4b8jh56bd3zrqdb0bwhbbzdxycc952fb0j6m62fw";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"

    cp -R * "$out/lib"

    cat > "$out/bin/umlet" << EOF
    #!${stdenv.shell}

    programDir="$out/lib"
    cd "\$programDir"
    if [ \$# -eq 1 ]
     then "${jre}/bin/java" -jar "\$programDir/umlet.jar" -filename="\$1"
     else "${jre}/bin/java" -jar "\$programDir/umlet.jar" "\$@"
    fi

    EOF
    chmod a+x "$out/bin/umlet"
  '';

  meta = with stdenv.lib; {
    description = "Free, open-source UML tool with a simple user interface";
    longDescription = ''
      UMLet is a free, open-source UML tool with a simple user interface:
      draw UML diagrams fast, produce sequence and activity diagrams from
      plain text, export diagrams to eps, pdf, jpg, svg, and clipboard,
      share diagrams using Eclipse, and create new, custom UML elements.
      UMLet runs stand-alone or as Eclipse plug-in on Windows, macOS and
      Linux.
    '';
    homepage = http://www.umlet.com;
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
