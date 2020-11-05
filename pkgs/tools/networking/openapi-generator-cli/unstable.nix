{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "5.0.0-2020-11-04";
  pname = "openapi-generator-cli";

  jarfilename = "${pname}-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "https://oss.sonatype.org/content/repositories/snapshots/org/openapitools/openapi-generator-cli/5.0.0-SNAPSHOT/openapi-generator-cli-5.0.0-20201104.185152-853.jar";
    sha256 = "1g3wkzj6bavdagbmrg9j6nryawxphplvi5mw0zpdqy3jjb1d8z6q";
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

