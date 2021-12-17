{ lib, stdenv, fetchurl, makeWrapper
, coreutils, jdk, rlwrap, gnupg }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.9.7";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "sha256-948g0ZMfAoJw53vA8MAKWg76Tst6VnYwSjSuT0aeKB0=";
  };

  jarsrc = fetchurl {
    url = "https://github.com/technomancy/leiningen/releases/download/${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-gvAUFKzs3bsOvW1XFQW7Zxpv0JMja82sJGjP5fLqqAI=";
  };

  JARNAME = "${pname}-${version}-standalone.jar";

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
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
      --prefix PATH ":" "${lib.makeBinPath [ rlwrap coreutils ]}" \
      --set LEIN_GPG ${gnupg}/bin/gpg \
      --set JAVA_CMD ${jdk}/bin/java
  '';

  meta = {
    homepage = "https://leiningen.org/";
    description = "Project automation for Clojure";
    license = lib.licenses.epl10;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ thiagokokada ];
  };
}
