{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "3.3.4";
  pname = "openapi-generator-cli";

  jarfilename = "${pname}-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "http://central.maven.org/maven2/org/openapitools/${pname}/${version}/${jarfilename}";
    sha256 = "24cb04939110cffcdd7062d2f50c6f61159dc3e0ca3b8aecbae6ade53ad3dc8c";
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

