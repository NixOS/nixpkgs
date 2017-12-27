{stdenv, fetchurl, unzip, jre, ...}:

stdenv.mkDerivation rec {
    version = "2.5.1";
    name = "jbake-${version}";
    src = fetchurl {
        url = "http://jbake.org/files/jbake-${version}-bin.zip";
        sha256="1r46y84q5x915055hx2vxydaqng3cz0clwz0yhwapgmi4sliygjd";
    };

    buildInputs = [ unzip jre ];

    unpackPhase = "unzip ${src}";

    installPhase = ''
        substituteInPlace $name/bin/jbake --replace "java" "${jre}/bin/java" 
        mkdir -p $out
        cp -r $name/* $out
    '';

    meta = with stdenv; {
        description = "JBake is a Java based, open source, static site/blog generator for developers & designers";
        homepage = "http://jbake.org/";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [moaxcp];
    };
}
