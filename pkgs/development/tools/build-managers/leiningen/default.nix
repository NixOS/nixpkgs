{ lib, stdenv, fetchurl, makeWrapper
, coreutils, jdk, rlwrap, gnupg }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.11.2";

  src = fetchurl {
    url = "https://codeberg.org/leiningen/leiningen/raw/tag/${version}/bin/lein-pkg";
    hash = "sha256-KKGmJmjF9Ce0E6hnfjdq/6qZXwI7H80G4tTJisHfXz4=";
  };

  jarsrc = fetchurl {
    url = "https://codeberg.org/leiningen/leiningen/releases/download/${version}/leiningen-${version}-standalone.jar";
    hash = "sha256-fTGuI652npJ0OLDNVdFak+faurCf1PwVh3l5Fh4Qh3Q=";
  };

  JARNAME = "${pname}-${version}-standalone.jar";

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ jdk ];

  # the jar is not in share/java, because it's a standalone jar and should
  # never be picked up by set-java-classpath.sh

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -v $src $out/bin/lein
    cp -v $jarsrc $out/share/$JARNAME

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    chmod +x $out/bin/lein
    patchShebangs $out/bin/lein
    substituteInPlace $out/bin/lein \
      --replace 'LEIN_JAR=/usr/share/java/leiningen-$LEIN_VERSION-standalone.jar' "LEIN_JAR=$out/share/$JARNAME"
    wrapProgram $out/bin/lein \
      --prefix PATH ":" "${lib.makeBinPath [ rlwrap coreutils ]}" \
      --set LEIN_GPG ${gnupg}/bin/gpg \
      --set JAVA_CMD ${jdk}/bin/java

    runHook postFixup
  '';

  meta = {
    homepage = "https://leiningen.org/";
    description = "Project automation for Clojure";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    platforms = jdk.meta.platforms;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "lein";
  };
}
