{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "google-java-format";
  version = "1.14.0";

  src = fetchurl {
    url = "https://github.com/google/google-java-format/releases/download/v${version}/google-java-format-${version}-all-deps.jar";
    sha256 = "sha256-DSfT5Yw6nZHYm0JNRn+r3iToxntGYmBhU7zQGzg+vXc=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}}
    install -D ${src} $out/share/${pname}/google-java-format-${version}-all-deps.jar

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --argv0 ${pname} \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED" \
      --add-flags "--add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED" \
      --add-flags "-jar $out/share/${pname}/google-java-format-${version}-all-deps.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Java source formatter by Google";
    longDescription = ''
      A program that reformats Java source code to comply with Google Java Style.
    '';
    homepage = "https://github.com/google/google-java-format";
    license = licenses.asl20;
    maintainers = [ maintainers.emptyflask ];
    platforms = platforms.all;
  };
}
