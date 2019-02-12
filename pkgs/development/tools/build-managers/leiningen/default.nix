{ stdenv, fetchurl, makeWrapper
, coreutils, jdk, rlwrap, gnupg1compat }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.8.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "1jbrm4vdvwskbi9sxvn6i7h2ih9c3nfld63nx58nblghvlcb9vwx";
  };

  jarsrc = fetchurl {
    # NOTE: This is actually a .jar, Github has issues
    url = "https://github.com/technomancy/leiningen/releases/download/${version}/${name}-standalone.zip";
    sha256 = "07kb7d84llp24l959gndnfmislnnvgpsxghmgfdy8chy7g4sy2kz";
  };

  JARNAME = "${name}-standalone.jar";

  unpackPhase = "true";

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ jdk ];

  # the jar is not in share/java, because it's a standalone jar and should
  # never be picked up by set-java-classpath.sh

  installPhase = ''
    mkdir -p $out/bin $out/share

    cp -v $src $out/bin/lein
    cp -v $jarsrc $out/share/$JARNAME
  '';

  fixupPhase = ''
    chmod +x $out/bin/lein
    patchShebangs $out/bin/lein

    substituteInPlace $out/bin/lein \
      --replace 'LEIN_JAR=/usr/share/java/leiningen-$LEIN_VERSION-standalone.jar' "LEIN_JAR=$out/share/$JARNAME"

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
