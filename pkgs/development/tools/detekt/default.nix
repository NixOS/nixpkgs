{ detekt, lib, stdenv, fetchurl, makeWrapper, jre_headless, testers }:
stdenv.mkDerivation rec {
  pname = "detekt";
  version = "1.23.3";

  jarfilename = "${pname}-${version}-executable.jar";

  src = fetchurl {
    url = "https://github.com/detekt/detekt/releases/download/v${version}/detekt-cli-${version}-all.jar";
    sha256 = "sha256-Lm9z8XB7BdB7ikiyJyuVtV8eqlPucxmMNNC90E99qpA=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D "$src" "$out/share/java/${jarfilename}"

    makeWrapper ${jre_headless}/bin/java $out/bin/detekt \
      --add-flags "-jar $out/share/java/${jarfilename}"

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = detekt; };

  meta = with lib; {
    description = "Static code analysis for Kotlin";
    homepage = "https://detekt.dev/";
    license = licenses.asl20;
    platforms = jre_headless.meta.platforms;
    maintainers = with maintainers; [ mdr ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
