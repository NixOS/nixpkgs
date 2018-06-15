{ stdenv, fetchurl, makeWrapper
, coreutils, jdk, rlwrap, gnupg1compat }:

stdenv.mkDerivation rec {
  pname = "leiningen";
  version = "2.8.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
    sha256 = "0wk4m7m66xxx7i3nis08mc8qna7acgcmpim562vdyyrpbxdhj24i";
  };

  jarsrc = fetchurl {
    # NOTE: This is actually a .jar, Github has issues
    url = "https://github.com/technomancy/leiningen/releases/download/${version}/${name}-standalone.zip";
    sha256 = "0n3wkb0a9g25r1xq93lskay2lw210qymz2qakjnl5vr5zz3vnjgw";
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
