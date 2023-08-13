{ lib, stdenv, fetchurl, makeWrapper
, coreutils, jdk, rlwrap, gnupg }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.10.0";

  src = fetchurl {
    url = "https://codeberg.org/leiningen/leiningen/raw/tag/${version}/bin/lein-pkg";
    hash = "sha256-sXV86UHky/Fcv2Sbe09BM2XmEtqJLSKEHsFyg5G7Zq8=";
  };

  # Check https://codeberg.org/leiningen/leiningen/releases to get the URL for the new version
  jarsrc = fetchurl {
    url = "https://codeberg.org/attachments/43cebda5-a7c2-405b-b641-5143a00051b5";
    hash = "sha256-0nKZutNAdawoZNC9BVn4NcbixHbAsKKDvL21dP2tuzQ=";
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
