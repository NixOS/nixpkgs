{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "4.0.0";
  pname = "openapi-generator-cli";

  jarfilename = "${pname}-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "http://central.maven.org/maven2/org/openapitools/${pname}/${version}/${jarfilename}";
    sha256 = "0011cks5qizq1rl8iwm683gmb9dlx134p8az32vqm8sbivggv9c1";
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

