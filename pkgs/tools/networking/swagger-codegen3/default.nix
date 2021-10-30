{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "3.0.29";
  pname = "swagger-codegen";

  jarfilename = "${pname}-cli-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/io/swagger/codegen/v3/${pname}-cli/${version}/${jarfilename}";
    sha256 = "sha256-sEwqUmtWaoBV0QmdP8ibm3neqWHk7+tWLAuO2FaCUtQ=";
  };

  dontUnpack = true;

  installPhase = ''
    install -D $src $out/share/java/${jarfilename}

    makeWrapper ${jre}/bin/java $out/bin/${pname}3 \
      --add-flags "-jar $out/share/java/${jarfilename}"
  '';

  meta = with lib; {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/swagger-api/swagger-codegen/tree/3.0.0";
    license = licenses.asl20;
    maintainers = [ maintainers._1000101 ];
  };
}
