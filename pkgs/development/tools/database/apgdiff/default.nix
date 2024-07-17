{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jre,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  version = "2.7.0";
  pname = "apgdiff";

  src = fetchurl {
    url = "https://github.com/fordfrog/apgdiff/raw/release_${finalAttrs.version}/releases/apgdiff-${finalAttrs.version}.jar";
    sha256 = "sha256-6OempDmedl6LOwP/s5y0hOIxGDWHd7qM7/opW3UwQ+I=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    install -Dm644 $src $out/lib/apgdiff.jar

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/apgdiff \
      --argv0 apgdiff \
      --add-flags "-jar $out/lib/apgdiff.jar"
  '';

  meta = with lib; {
    description = "Another PostgreSQL diff tool";
    mainProgram = "apgdiff";
    homepage = "https://apgdiff.com";
    license = licenses.mit;
    inherit (jre.meta) platforms;
    sourceProvenance = [ sourceTypes.binaryBytecode ];
    maintainers = [ maintainers.misterio77 ];
  };
})
