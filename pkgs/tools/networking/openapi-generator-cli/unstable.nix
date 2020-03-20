{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "5.0.0-2020-02-04";
  pname = "openapi-generator-cli";

  jarfilename = "${pname}-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "https://oss.sonatype.org/content/repositories/snapshots/org/openapitools/openapi-generator-cli/5.0.0-SNAPSHOT/openapi-generator-cli-5.0.0-20200204.091421-37.jar";
    sha256 = "0swv976fcr2z8g53avr0r706c31xacb2dlnl8b4c8mzmi49byy7k";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    install -D "$src" "$out/share/java/${jarfilename}"

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${jarfilename}"
  '';

  meta = with stdenv.lib; {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = https://github.com/OpenAPITools/openapi-generator;
    license = licenses.asl20;
    maintainers = [ maintainers.shou ];
  };
}

