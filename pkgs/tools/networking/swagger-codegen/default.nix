{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "3.0.20";
  pname = "swagger-codegen-cli";

  jarfilename = "${pname}-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = self.fetchurl {
    url = "https://repo1.maven.org/maven2/io/swagger/codegen/v3/${pname}/${version}/${jarfilename}";
    sha256 = "02jjxsg9lk5sp5052yzc9v3cvd6k3d7i475clvhsczswz1mmp08x";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    install -D "$src" "$out/share/java/${jarfilename}"

    makeWrapper ${jre}/bin/java $out/bin/swagger-codegen \
      --add-flags "-jar $out/share/java/${jarfilename}"
  '';

  meta = with stdenv.lib; {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/swagger-api/swagger-codegen";
    license = licenses.asl20;
    maintainers = [ maintainers.jraygauthier ];
  };
}
