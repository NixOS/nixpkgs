{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "2.2.1";
  pname = "swagger-codegen";
  name = "${pname}-${version}";

  jarfilename = "${pname}-cli-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "https://oss.sonatype.org/content/repositories/releases/io/swagger/${pname}-cli/${version}/${jarfilename}";
    sha256 = "1pwxkl3r93c8hsif9xm0h1hmbjrxz1q7hr5qn5n0sni1x3c3k0d1";
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
