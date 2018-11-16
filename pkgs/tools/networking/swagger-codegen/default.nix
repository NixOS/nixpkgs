{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "2.3.1";
  pname = "swagger-codegen";
  name = "${pname}-${version}";

  jarfilename = "${pname}-cli-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "https://oss.sonatype.org/content/repositories/releases/io/swagger/${pname}-cli/${version}/${jarfilename}";
    sha256 = "171qr0zx7i6cykv54vqjf3mplrf7w4a1fpq47wsj861lbf8xm322";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    install -D "$src" "$out/share/java/${jarfilename}"

    makeWrapper ${jre}/bin/java $out/bin/swagger-codegen \
      --add-flags "-jar $out/share/java/${jarfilename}"
  '';

  meta = with stdenv.lib; {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = https://github.com/swagger-api/swagger-codegen;
    license = licenses.asl20;
    maintainers = [ maintainers.jraygauthier ];
  };
}
