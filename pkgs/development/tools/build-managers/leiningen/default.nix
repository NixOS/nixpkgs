{ stdenv, fetchurl, makeWrapper
, coreutils, jdk, rlwrap, gnupg1compat }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.7.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "0rmshl4xchf3blwvar4q9dpxm9xznn3yzas4vwxqiq3yhapgqkn0";
  };

  jarsrc = fetchurl {
    # NOTE: This is actually a .jar, Github has issues
    url = "https://github.com/technomancy/leiningen/releases/download/${version}/${name}-standalone.zip";
    sha256 = "0ivwb1qlxs1hyical0fjgavm9wfkw3f10sk67p5g2p5lpf4pxp1d";
  };

  JARNAME = "${name}-standalone.jar";

  unpackPhase = "true";

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ jdk ];

  installPhase = ''
    mkdir -p $out/bin $out/share/java

    cp -v $src $out/bin/lein
    cp -v $jarsrc $out/share/java/$JARNAME
  '';

  fixupPhase = ''
    chmod +x $out/bin/lein
    patchShebangs $out/bin/lein

    substituteInPlace $out/bin/lein \
      --replace 'LEIN_JAR=/usr/share/java/leiningen-$LEIN_VERSION-standalone.jar' "LEIN_JAR=$out/share/java/$JARNAME"

    wrapProgram $out/bin/lein \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ rlwrap coreutils ]}" \
      --set LEIN_GPG ${gnupg1compat}/bin/gpg \
      --set JAVA_CMD ${jdk}/bin/java
  '';

  meta = {
    homepage = https://leiningen.org/;
    description = "Project automation for Clojure";
    license = stdenv.lib.licenses.epl10;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
