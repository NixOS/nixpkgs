{ lib, stdenv, fetchurl, jre, unzip, runtimeShell }:

let
  major = "15";
  minor = "0";
  patch = "0";
in stdenv.mkDerivation rec {
  pname = "umlet";
  version = "${major}.${minor}.${patch}";

  src = fetchurl {
    url = "https://www.umlet.com/umlet_${major}_${minor}/umlet-standalone-${version}.zip";
    sha256 = "sha256-gdvhqYGyrFuQhhrkF26wXb3TQLRCLm59/uSxTPmHdAE=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/lib"

    cp -R * "$out/lib"

    cat > "$out/bin/umlet" << EOF
    #!${runtimeShell}

    programDir="$out/lib"
    cd "\$programDir"
    if [ \$# -eq 1 ]
     then "${jre}/bin/java" -jar "\$programDir/umlet.jar" -filename="\$1"
     else "${jre}/bin/java" -jar "\$programDir/umlet.jar" "\$@"
    fi

    EOF
    chmod a+x "$out/bin/umlet"
  '';

  meta = with lib; {
    description = "Free, open-source UML tool with a simple user interface";
    longDescription = ''
      UMLet is a free, open-source UML tool with a simple user interface:
      draw UML diagrams fast, produce sequence and activity diagrams from
      plain text, export diagrams to eps, pdf, jpg, svg, and clipboard,
      share diagrams using Eclipse, and create new, custom UML elements.
      UMLet runs stand-alone or as Eclipse plug-in on Windows, macOS and
      Linux.
    '';
    homepage = "https://www.umlet.com";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3;
    maintainers = with maintainers; [ oxzi ];
    platforms = platforms.all;
  };
}
