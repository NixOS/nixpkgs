{ stdenv, fetchurl, sourceFromHead, apacheAnt, tomcat, jre }:

let 

  sources =
    [ (fetchurl {
        name = "jigsaw_2.2.6.tar.gz";
        url="http://jigsaw.w3.org/Distrib/jigsaw_2.2.6.tar.gz";
        sha256 = "01cjpqjcs8gbvvzy0f488cb552f9b38hvwr97wydglrzndmcwypd";
      })
      (fetchurl {
        name = "commons-collectionurl3.2.1-bin.tar.gz";
        url="http://www.apache.org/dist/commons/collections/binaries/commons-collections-3.2.1-bin.tar.gz";
        sha256 = "7843f8307495b2be446353b10c25218793b776fa3e22615a1f50f067d81713ce";
      })
      (fetchurl {
        name = "commons-lang-2.4-bin.tar.gz";
        url="http://www.apache.org/dist/commons/lang/binaries/commons-lang-2.4-bin.tar.gz";
        sha256 = "0phwlgnvwj3n3j1aka2pkm0biacvgs72qc0ldir6s69i9qbv7rh0";
      })
      (fetchurl {
        name = "velocity-1.6.1.tar.gz";
        url="http://www.apache.org/dist/velocity/engine/1.6.1/velocity-1.6.1.tar.gz";
        sha256 = "125s8yp8whx947kahm902wc49ms44knxdj6yfskhpk0a8h0rz9jm";
      })
      (fetchurl {
        name = "Xerces-J-bin.2.9.1.tar.gz";
        url="http://www.apache.org/dist/xerces/j/Xerces-J-bin.2.9.1.tar.gz";
        sha256 = "1xlrrznfgdars0a9m9z5k9q8arbqskdfdfjx4s0pp52wn3r0gbns";
      })
    ];

in

stdenv.mkDerivation {
  name = "w3c-css-validator";

  # REGION AUTO UPDATE:       { name="w3c-css-validator"; type="cvs"; cvsRoot=":pserver:anonymous:anonymous@dev.w3.org:/sources/public"; module="2002/css-validator"; }
  src = sourceFromHead "w3c-css-validator-F_17-52-37.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/w3c-css-validator-F_17-52-37.tar.gz"; sha256 = "b6f05d4812eaa464906d101242689effa8b5516d32d6420315740a77d8ee11fd"; });
  # END

  buildInputs = [ apacheAnt ];

  # prepare target downloads dependency .tar.gz into tmp
  # note: There is a .war as well which could be deployed to tomcat
  installPhase = ''
    cd css-validator
    mkdir tmp
    ${ stdenv.lib.concatStringsSep "\n" (map (src: "tar xfz ${src} -C tmp") sources) }
    sed -i -e 's@<property name="servlet.lib" value=".*"/>@<property name="servlet.lib" value="${tomcat}/lib/servlet-api.jar"/>@' \
          -e '/dest="tmp\//d' \
          -e '/untar/d' \
          build.xml
    ant
    mkdir -p $out/{bin,lib}
    JAR=$out/lib/css-validator.jar
    cat >> $out/bin/css-validator << EOF
    #!/bin/sh
    exec ${jre}/bin/java -jar $JAR "\$@"
    EOF
    chmod +x $out/bin/css-validator
    cp css-validator.jar $out/lib
    cp -r lib $out/lib/lib
  '';

  meta = {
    description = "W3C CSS validator";
    homepage = http://dev.w3.org/cvsweb/2002/css-validator/;
    # dependencies ship their own license files
    # I think all .java files are covered by this license (?)
    license = "w3c"; # http://www.w3.org/Consortium/Legal/ 
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
    broken = true;
  };
}
