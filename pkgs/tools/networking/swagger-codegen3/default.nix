{ lib, stdenv, fetchurl, jre, makeWrapper, testers, swagger-codegen3 }:

stdenv.mkDerivation rec {
  version = "3.0.52";
  pname = "swagger-codegen";

  jarfilename = "${pname}-cli-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "mirror://maven/io/swagger/codegen/v3/${pname}-cli/${version}/${jarfilename}";
    sha256 = "sha256-bBiETNzgySrOSFUB6356jiwDhwQ34QrOf2KdP5lv3Yg=";
  };

  dontUnpack = true;

  installPhase = ''
    install -D $src $out/share/java/${jarfilename}

    makeWrapper ${jre}/bin/java $out/bin/${pname}3 \
      --add-flags "-jar $out/share/java/${jarfilename}"
  '';

  passthru.tests.version = testers.testVersion {
    package = swagger-codegen3;
    command = "swagger-codegen3 version";
  };

  meta = with lib; {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/swagger-api/swagger-codegen/tree/3.0.0";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = [ maintainers._1000101 ];
    mainProgram = "swagger-codegen3";
  };
}
