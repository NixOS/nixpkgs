{ lib, stdenv, fetchzip, jdk, jre, ant, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "paros";
  version = "3.2.13";

  src = fetchzip {
    url = "mirror://sourceforge/paros/Paros/Version%20${version}/paros-${version}-src.zip";
    sha256 = "073zqn6a1ms9wcf29sssjzfvcx9f5lfwzj3gck6p0pc2ay1f9f66";
  };

  postPatch = ''
    # Set javac encoding option
    substituteInPlace build/build.xml \
      --replace "<javac" '<javac encoding="ISO-8859-1"'
  '';

  nativeBuildInputs = [
    jdk
    ant
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    cd build/
    ant

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r paros $out/share/paros

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${jre}/bin/java $out/bin/paros \
      --chdir "$out/share/paros" \
      --add-flags "-jar $out/share/paros/paros.jar"
  '';

  meta = with lib; {
    description = "HTTP/HTTPS proxy for assessing web application vulnerabilities";
    longDescription = ''
      A Java based HTTP/HTTPS proxy for assessing web application vulnerability.
      It supports editing/viewing HTTP messages on-the-fly. Other featuers include
      spiders, client certificate, proxy-chaining, intelligent scanning for XSS
      and SQL injections etc.
    '';
    homepage = "https://sourceforge.net/projects/paros/";
    license = with licenses; [ clArtistic asl20 bsd3 lgpl21Only ];
    sourceProvenance = with sourceTypes; [ fromSource binaryBytecode ];
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.all;
  };
}
