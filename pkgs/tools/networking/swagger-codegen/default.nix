{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "2.4.17";
  pname = "swagger-codegen";

  jarfilename = "${pname}-cli-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/io/swagger/${pname}-cli/${version}/${jarfilename}";
    sha256 = "06xx42ayh4xqpr71lq1hj7kv1v6m9ld9jm1d15fhs935zqckv32a";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    install -D "$src" "$out/share/java/${jarfilename}"

    makeWrapper ${jre}/bin/java $out/bin/swagger-codegen \
      --add-flags "-jar $out/share/java/${jarfilename}"
  '';

  meta = with lib; {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/swagger-api/swagger-codegen";
    license = licenses.asl20;
    maintainers = [ maintainers.jraygauthier ];
  };
}
