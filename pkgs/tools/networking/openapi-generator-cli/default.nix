{ callPackage, lib, stdenv, fetchurl, jre, makeWrapper }:

let this = stdenv.mkDerivation (finalAttrs: {
  version = "7.6.0";
  pname = "openapi-generator-cli";

  jarfilename = "${finalAttrs.pname}-${finalAttrs.version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "mirror://maven/org/openapitools/${finalAttrs.pname}/${finalAttrs.version}/${finalAttrs.jarfilename}";
    sha256 = "sha256-NQdL3TzfxGvpqQLhGlSj+qPK4eNOtmy9lZ0cgHC719c=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D "$src" "$out/share/java/${finalAttrs.jarfilename}"

    makeWrapper ${jre}/bin/java $out/bin/${finalAttrs.pname} \
      --add-flags "-jar $out/share/java/${finalAttrs.jarfilename}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/OpenAPITools/openapi-generator";
    changelog = "https://github.com/OpenAPITools/openapi-generator/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ shou ];
    mainProgram = "openapi-generator-cli";
  };

  passthru.tests.example = callPackage ./example.nix {
    openapi-generator-cli = this;
  };
});
in this
