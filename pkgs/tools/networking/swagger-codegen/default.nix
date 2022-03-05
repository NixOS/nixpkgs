{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  version = "2.4.19";
  pname = "swagger-codegen";

  jarfilename = "${pname}-cli-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "mirror://maven/io/swagger/${pname}-cli/${version}/${jarfilename}";
    sha256 = "04wl5k8k1ziqz7k5w0g7i6zdfn41pbh3k0m8vq434k1886inf8yn";
  };

  dontUnpack = true;

  installPhase = ''
    install -D $src $out/share/java/${jarfilename}

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${jarfilename}"
  '';

  meta = with lib; {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/swagger-api/swagger-codegen";
    license = licenses.asl20;
    maintainers = [ maintainers.jraygauthier ];
  };
}
