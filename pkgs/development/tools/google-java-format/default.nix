{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "google-java-format";
  version = "1.11.0";

  src = fetchurl {
    url = "https://github.com/google/google-java-format/releases/download/v${version}/google-java-format-${version}-all-deps.jar";
    sha256 = "1ixpg8ljg819fq94mxyypknmslva3rkifphbnq3ic71b7iip6lia";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/google-java-format}
    install -D ${src} $out/share/google-java-format/google-java-format.jar

    makeWrapper ${jre}/bin/java $out/bin/google-java-format \
      --add-flags "-jar $out/share/google-java-format/google-java-format.jar"

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
